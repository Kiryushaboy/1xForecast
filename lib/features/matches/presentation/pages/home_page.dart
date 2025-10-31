import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/state_widget.dart';
import '../bloc/match_bloc.dart';
import '../widgets/matchup_card.dart';
import '../widgets/stats_card.dart';
import '../../data/datasources/bet_parser_service.dart';
import '../../domain/entities/matchup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildContent(context),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final appBarHeight = AppTheme.getAppBarHeight(context);

    return SliverAppBar(
      expandedHeight: appBarHeight,
      pinned: true,
      backgroundColor: context.surfaceColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: UiConstants.spacingLarge,
          bottom: UiConstants.spacingLarge,
        ),
        title: Text(
          '1xForecast',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.isMobile
                ? UiConstants.fontSizeXLarge
                : UiConstants.fontSizeXXLarge + 2,
            color: Colors.white,
            letterSpacing: UiConstants.letterSpacingWide,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(UiConstants.borderRadiusHuge),
              bottomRight: Radius.circular(UiConstants.borderRadiusHuge),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(UiConstants.spacingLarge),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(UiConstants.borderRadiusXLarge),
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    size: context.isMobile ? 40 : UiConstants.iconSizeXXLarge,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: UiConstants.spacingMedium),
                Text(
                  'FIFA FC24 4x4',
                  style: TextStyle(
                    color: Colors.white.withOpacity(UiConstants.opacityVeryHigh),
                    fontSize: context.isMobile
                        ? UiConstants.fontSizeMedium
                        : UiConstants.fontSizeRegular,
                    fontWeight: FontWeight.w400,
                    letterSpacing: UiConstants.letterSpacingExtraWide,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) => IconButton(
            icon: Icon(
              mode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Colors.white,
            ),
            tooltip: mode == ThemeMode.dark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: context.read<ThemeCubit>().toggleTheme,
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: Colors.white),
          tooltip: 'Обновить',
          onPressed: () => context.read<MatchBloc>().add(LoadMatches()),
        ),
        SizedBox(width: UiConstants.spacingXSmall),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading) {
              return const StateWidget.loading();
            }

            if (state is MatchError) {
              return StateWidget.error(
                message: state.message,
                onRetry: () => context.read<MatchBloc>().add(LoadMatches()),
              );
            }

            if (state is MatchLoaded) {
              final matches = state.matches;
              if (matches.isEmpty) {
                return const StateWidget.empty();
              }

              final matchups = _groupMatchesByMatchup(matches);
              return _buildMatchupsContent(context, matchups, matches.length);
            }

            return const StateWidget.empty();
          },
        ),
      ),
    );
  }

  List<Matchup> _groupMatchesByMatchup(List matches) {
    final Map<String, int> matchupCounts = {};
    
    for (var match in matches) {
      final key = '${match.homeTeam}|${match.awayTeam}';
      matchupCounts[key] = (matchupCounts[key] ?? 0) + 1;
    }

    return matchupCounts.entries.map((entry) {
      final teams = entry.key.split('|');
      return Matchup(
        homeTeam: teams[0],
        awayTeam: teams[1],
        matchCount: entry.value,
      );
    }).toList();
  }

  Widget _buildMatchupsContent(
    BuildContext context,
    List<Matchup> matchups,
    int totalMatches,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsHeader(context, matchups.length, totalMatches),
        SizedBox(
          height: context.isMobile
              ? UiConstants.spacingXXLarge
              : UiConstants.spacingHuge,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: UiConstants.spacingXSmall,
            bottom: UiConstants.spacingLarge,
          ),
          child: Text(
            'Противостояния',
            style: TextStyle(
              fontSize: context.isMobile
                  ? UiConstants.fontSizeXLarge
                  : UiConstants.fontSizeXXLarge,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: UiConstants.letterSpacingNormal,
            ),
          ),
        ),
        _buildMatchupsList(context, matchups),
      ],
    );
  }

  Widget _buildStatsHeader(
      BuildContext context, int matchupsCount, int totalMatches) {
    return Row(
      children: [
        StatsCard(
          icon: Icons.group_rounded,
          value: matchupsCount,
          label: 'Команд',
          gradient: AppTheme.primaryGradient,
          shadowColor: AppTheme.primaryBlue,
        ),
        SizedBox(
          width: context.isMobile
              ? UiConstants.spacingMedium
              : UiConstants.spacingLarge,
        ),
        StatsCard(
          icon: Icons.sports_soccer_rounded,
          value: totalMatches,
          label: 'Матчей',
          gradient: AppTheme.successGradient,
          shadowColor: AppTheme.accentGreen,
        ),
      ],
    );
  }

  Widget _buildMatchupsList(BuildContext context, List<Matchup> matchups) {
    if (context.isMobile) {
      return Column(
        children: matchups
            .map((m) => MatchupCard(
                  homeTeam: m.homeTeam,
                  awayTeam: m.awayTeam,
                  matchCount: m.matchCount,
                  onTap: () => context.go('/analysis/${m.homeTeam}/${m.awayTeam}'),
                ))
            .toList(),
      );
    }

    return _buildGrid(
      context,
      matchups,
      context.gridColumns,
      context.isTablet ? UiConstants.spacingMedium : UiConstants.spacingLarge,
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<Matchup> matchups,
    int columns,
    double spacing,
  ) {
    return Column(
      children: List.generate((matchups.length / columns).ceil(), (rowIndex) {
        final start = rowIndex * columns;
        final end = (start + columns).clamp(0, matchups.length);
        final rowItems = matchups.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            children: [
              for (var i = 0; i < rowItems.length; i++) ...[
                Expanded(
                  child: MatchupCard(
                    homeTeam: rowItems[i].homeTeam,
                    awayTeam: rowItems[i].awayTeam,
                    matchCount: rowItems[i].matchCount,
                    onTap: () => context.go(
                      '/analysis/${rowItems[i].homeTeam}/${rowItems[i].awayTeam}',
                    ),
                  ),
                ),
                if (i < rowItems.length - 1) SizedBox(width: spacing),
              ],
              if (rowItems.length < columns)
                ...List.generate(
                  columns - rowItems.length,
                  (_) => Expanded(child: SizedBox()),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusXXLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: UiConstants.elevationHuge,
            offset: const Offset(0, UiConstants.elevationHigh),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _handleLoadData(context),
        elevation: 0,
        icon: const Icon(Icons.download_rounded, size: UiConstants.fontSizeXXLarge),
        label: const Text(
          'Загрузить',
          style: TextStyle(
            fontSize: UiConstants.fontSizeRegular,
            fontWeight: FontWeight.w600,
            letterSpacing: UiConstants.letterSpacingNormal,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLoadData(BuildContext context) async {
    try {
      final betParser = BetParserService();
      final matches = await betParser.fetchMatches();

      if (context.mounted) {
        context.read<MatchBloc>().add(SaveMatches(matches));
        _showSuccessSnackBar(context, matches.length);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, e.toString());
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, int matchesCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: UiConstants.spacingMedium),
            Text('Загружено $matchesCount матчей'),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: UiConstants.spacingMedium),
            Text('Ошибка: $error'),
          ],
        ),
        backgroundColor: AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
        ),
      ),
    );
  }
}
