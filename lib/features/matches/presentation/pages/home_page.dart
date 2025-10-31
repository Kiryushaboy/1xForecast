import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/match_bloc.dart';
import '../../data/datasources/bet_parser_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/animated_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppTheme.getHorizontalPadding(context);
    final appBarHeight = AppTheme.getAppBarHeight(context);
    final isDark = AppTheme.isDarkMode(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Легкий воздушный AppBar
          SliverAppBar(
            expandedHeight: appBarHeight,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.getSurface(context),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                '1xForecast',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppTheme.isMobile(context) ? 20 : 24,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.sports_soccer,
                          size: AppTheme.isMobile(context) ? 40 : 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'FIFA FC24 4x4',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: AppTheme.isMobile(context) ? 13 : 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Кнопка переключения темы
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white,
                      ),
                      tooltip: themeMode == ThemeMode.dark
                          ? 'Светлая тема'
                          : 'Тёмная тема',
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  tooltip: 'Обновить',
                  onPressed: () {
                    context.read<MatchBloc>().add(LoadMatches());
                  },
                ),
              ),
            ],
          ),

          // Контент
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: BlocBuilder<MatchBloc, MatchState>(
                builder: (context, state) {
                  if (state is MatchLoading) {
                    return _buildLoadingState(context);
                  }

                  if (state is MatchError) {
                    return _buildErrorState(context, state.message);
                  }

                  if (state is MatchLoaded) {
                    final matches = state.matches;

                    if (matches.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    // Group matches by matchup
                    final matchups = <String, List>{};
                    for (var match in matches) {
                      final key = '${match.homeTeam} vs ${match.awayTeam}';
                      matchups.putIfAbsent(
                          key, () => [match.homeTeam, match.awayTeam, 0]);
                      matchups[key]![2]++;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Статистика
                        _buildStatsHeader(context, matchups.length, matches.length),
                        SizedBox(height: AppTheme.isMobile(context) ? 24 : 32),

                        // Заголовок списка
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 16),
                          child: Text(
                            'Противостояния',
                            style: TextStyle(
                              fontSize: AppTheme.isMobile(context) ? 20 : 22,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTextPrimary(context),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        // Адаптивный список/grid противостояний
                        _buildMatchupsList(context, matchups),
                      ],
                    );
                  }

                  return _buildEmptyState(context);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildMatchupsList(BuildContext context, Map<String, List> matchups) {
    // Для мобильных - список, для планшетов и десктопов - grid
    if (AppTheme.isMobile(context)) {
      return Column(
        children: matchups.entries.map((entry) {
          final homeTeam = entry.value[0] as String;
          final awayTeam = entry.value[1] as String;
          final matchCount = entry.value[2] as int;

          return _buildMatchupCard(
            context,
            homeTeam,
            awayTeam,
            matchCount,
          );
        }).toList(),
      );
    }

    // Grid для планшетов и десктопов
    final columns = AppTheme.getGridColumns(context);
    final entries = matchups.entries.toList();
    final rows = (entries.length / columns).ceil();
    final spacing = AppTheme.isTablet(context) ? 12.0 : 16.0;

    return Column(
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * columns;
        final endIndex = (startIndex + columns).clamp(0, entries.length);
        final rowEntries = entries.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < rowEntries.length; i++) ...[
                Expanded(
                  child: _buildMatchupCard(
                    context,
                    rowEntries[i].value[0] as String,
                    rowEntries[i].value[1] as String,
                    rowEntries[i].value[2] as int,
                  ),
                ),
                if (i < rowEntries.length - 1) SizedBox(width: spacing),
              ],
              // Заполнители для выравнивания
              if (rowEntries.length < columns)
                ...List.generate(
                  columns - rowEntries.length,
                  (index) => Expanded(child: SizedBox(width: spacing)),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsHeader(BuildContext context, int matchupsCount, int totalMatches) {
    final isMobile = AppTheme.isMobile(context);
    
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.group_rounded,
                    size: isMobile ? 24 : 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 14),
                Text(
                  '$matchupsCount',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 6),
                Text(
                  'Команд',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: isMobile ? 12 : 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              gradient: AppTheme.successGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.sports_soccer_rounded,
                    size: isMobile ? 24 : 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 14),
                Text(
                  '$totalMatches',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 6),
                Text(
                  'Матчей',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchupCard(
    BuildContext context,
    String homeTeam,
    String awayTeam,
    int matchCount,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.getCard(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.isDarkMode(context) 
                  ? Colors.black.withOpacity(0.15)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go('/analysis/$homeTeam/$awayTeam');
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Мягкий badge с количеством
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        '$matchCount',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Информация
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeTeam,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getTextPrimary(context),
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.getTextSecondary(context).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getTextSecondary(context),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                awayTeam,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.getTextPrimary(context),
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Мягкая стрелка
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          PulseAnimation(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Загрузка матчей...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.dangerGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ошибка загрузки',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<MatchBloc>().add(LoadMatches());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppTheme.warningGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentOrange.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Нет данных',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Загрузите матчи для начала работы',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final betParser = BetParserService();
            final matches = await betParser.fetchMatches();

            if (context.mounted) {
              context.read<MatchBloc>().add(SaveMatches(matches));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text('Загружено ${matches.length} матчей'),
                    ],
                  ),
                  backgroundColor: AppTheme.accentGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Text('Ошибка: $e'),
                    ],
                  ),
                  backgroundColor: AppTheme.accentRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }
          }
        },
        elevation: 0,
        icon: const Icon(Icons.download_rounded, size: 22),
        label: const Text(
          'Загрузить',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
