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
          // Красивый анимированный AppBar
          SliverAppBar(
            expandedHeight: appBarHeight,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.getSurface(context),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '1xForecast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTheme.isMobile(context) ? 20 : 24,
                  color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.sports_soccer,
                        size: AppTheme.isMobile(context) ? 50 : 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'FIFA FC24 4x4',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: AppTheme.isMobile(context) ? 14 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Кнопка переключения темы
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return IconButton(
                    icon: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
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
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Обновить',
                onPressed: () {
                  context.read<MatchBloc>().add(LoadMatches());
                },
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
                        const SizedBox(height: 20),

                        // Заголовок списка
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Противостояния',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 12),

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

    return Column(
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * columns;
        final endIndex = (startIndex + columns).clamp(0, entries.length);
        final rowEntries = entries.sublist(startIndex, endIndex);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowEntries.map((entry) {
              final homeTeam = entry.value[0] as String;
              final awayTeam = entry.value[1] as String;
              final matchCount = entry.value[2] as int;

              return Expanded(
                child: _buildMatchupCard(
                  context,
                  homeTeam,
                  awayTeam,
                  matchCount,
                ),
              );
            }).toList(),
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
          child: AnimatedGradientCard(
            gradient: AppTheme.primaryGradient,
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              children: [
                Icon(Icons.group, size: isMobile ? 28 : 32, color: Colors.white),
                SizedBox(height: isMobile ? 6 : 8),
                Text(
                  '$matchupsCount',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  'Противостояний',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedGradientCard(
            gradient: AppTheme.successGradient,
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              children: [
                Icon(Icons.sports_soccer, size: isMobile ? 28 : 32, color: Colors.white),
                SizedBox(height: isMobile ? 6 : 8),
                Text(
                  '$totalMatches',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  'Матчей',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: Colors.white70,
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
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        onTap: () {
          context.go('/analysis/$homeTeam/$awayTeam');
        },
        child: Row(
          children: [
            // Аватар с градиентом
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$matchCount',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'vs',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        awayTeam,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getTextPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$matchCount матчей в истории',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Стрелка
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
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
    return PulseAnimation(
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
        icon: const Icon(Icons.download_rounded, size: 24),
        label: const Text(
          'Загрузить данные',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
