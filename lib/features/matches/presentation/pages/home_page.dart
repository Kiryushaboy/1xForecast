import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/match_bloc.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_state_widget.dart';
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
    final isMobile = AppTheme.isMobile(context);

    return SliverAppBar(
      expandedHeight: appBarHeight,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.getSurface(context),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: UiConstants.spacingLarge,
          bottom: UiConstants.spacingLarge,
        ),
        title: Text(
          '1xForecast',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? UiConstants.fontSizeXLarge : UiConstants.fontSizeXXLarge + 2,
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
                    borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    size: isMobile ? 40 : UiConstants.iconSizeXXLarge,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: UiConstants.spacingMedium),
                Text(
                  'FIFA FC24 4x4',
                  style: TextStyle(
                    color: Colors.white.withOpacity(UiConstants.opacityVeryHigh),
                    fontSize: isMobile ? UiConstants.fontSizeMedium : UiConstants.fontSizeRegular,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiConstants.spacingXSmall),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                tooltip: themeMode == ThemeMode.dark ? 'Светлая тема' : 'Тёмная тема',
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: UiConstants.spacingSmall),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Обновить',
            onPressed: () => context.read<MatchBloc>().add(LoadMatches()),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final horizontalPadding = AppTheme.getHorizontalPadding(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading) {
              return const LoadingStateWidget();
            }

            if (state is MatchError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<MatchBloc>().add(LoadMatches()),
              );
            }

            if (state is MatchLoaded) {
              final matches = state.matches;
              if (matches.isEmpty) {
                return const EmptyStateWidget();
              }

              final matchups = _groupMatchesByMatchup(matches);
              return _buildMatchupsContent(context, matchups, matches.length);
            }

            return const EmptyStateWidget();
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
    final isMobile = AppTheme.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsHeader(context, matchups.length, totalMatches),
        SizedBox(height: isMobile ? UiConstants.spacingXXLarge : UiConstants.spacingHuge),
        Padding(
          padding: const EdgeInsets.only(
            left: UiConstants.spacingXSmall,
            bottom: UiConstants.spacingLarge,
          ),
          child: Text(
            'Противостояния',
            style: TextStyle(
              fontSize: isMobile ? UiConstants.fontSizeXLarge : UiConstants.fontSizeXXLarge,
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(context),
              letterSpacing: UiConstants.letterSpacingNormal,
            ),
          ),
        ),
        _buildMatchupsList(context, matchups),
      ],
    );
  }

  Widget _buildStatsHeader(BuildContext context, int matchupsCount, int totalMatches) {
    final isMobile = AppTheme.isMobile(context);

    return Row(
      children: [
        StatsCard(
          icon: Icons.group_rounded,
          value: matchupsCount,
          label: 'Команд',
          gradient: AppTheme.primaryGradient,
          shadowColor: AppTheme.primaryBlue,
        ),
        SizedBox(width: isMobile ? UiConstants.spacingMedium : UiConstants.spacingLarge),
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
    if (AppTheme.isMobile(context)) {
      return Column(
        children: matchups
            .map((matchup) => MatchupCard(
                  homeTeam: matchup.homeTeam,
                  awayTeam: matchup.awayTeam,
                  matchCount: matchup.matchCount,
                  onTap: () => context.go(
                    '/analysis/${matchup.homeTeam}/${matchup.awayTeam}',
                  ),
                ))
            .toList(),
      );
    }

    // Grid для планшетов и десктопов
    final columns = AppTheme.getGridColumns(context);
    final spacing = AppTheme.isTablet(context) 
        ? UiConstants.spacingMedium 
        : UiConstants.spacingLarge;

    return _buildGrid(context, matchups, columns, spacing);
  }

  Widget _buildGrid(
    BuildContext context,
    List<Matchup> matchups,
    int columns,
    double spacing,
  ) {
    final rows = (matchups.length / columns).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * columns;
        final endIndex = (startIndex + columns).clamp(0, matchups.length);
        final rowMatchups = matchups.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < rowMatchups.length; i++) ...[
                Expanded(
                  child: MatchupCard(
                    homeTeam: rowMatchups[i].homeTeam,
                    awayTeam: rowMatchups[i].awayTeam,
                    matchCount: rowMatchups[i].matchCount,
                    onTap: () => context.go(
                      '/analysis/${rowMatchups[i].homeTeam}/${rowMatchups[i].awayTeam}',
                    ),
                  ),
                ),
                if (i < rowMatchups.length - 1) SizedBox(width: spacing),
              ],
              if (rowMatchups.length < columns)
                ...List.generate(
                  columns - rowMatchups.length,
                  (index) => Expanded(child: SizedBox(width: spacing)),
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
