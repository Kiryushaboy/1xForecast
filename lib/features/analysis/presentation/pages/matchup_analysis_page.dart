import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/analysis_bloc.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_widgets.dart';
import '../../domain/entities/matchup_stats.dart';

class MatchupAnalysisPage extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;

  const MatchupAnalysisPage({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  State<MatchupAnalysisPage> createState() => _MatchupAnalysisPageState();
}

class _MatchupAnalysisPageState extends State<MatchupAnalysisPage>
    with TickerProviderStateMixin {
  MatchupStats? _stats;
  List<SeasonStats>? _seasonStats;
  late AnimationController _percentageController;
  late Animation<double> _percentageAnimation;

  @override
  void initState() {
    super.initState();
    _percentageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _percentageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _percentageController, curve: Curves.easeOut),
    );

    // Load stats
    context.read<AnalysisBloc>().add(
          LoadMatchupStats(
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
          ),
        );
    context.read<AnalysisBloc>().add(
          LoadSeasonStats(
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
          ),
        );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Красивый AppBar с градиентом
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.surfaceDark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.homeTeam}\nvs\n${widget.awayTeam}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Icon(
                      Icons.sports_soccer,
                      size: 50,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Контент
          SliverToBoxAdapter(
            child: BlocConsumer<AnalysisBloc, AnalysisState>(
              listener: (context, state) {
                if (state is MatchupStatsLoaded) {
                  setState(() {
                    _stats = state.stats;
                  });
                  _percentageController.forward();
                } else if (state is SeasonStatsLoaded) {
                  setState(() {
                    _seasonStats = state.stats;
                  });
                }
              },
              builder: (context, state) {
                if (state is AnalysisLoading && _stats == null) {
                  return _buildLoadingState();
                }

                if (state is AnalysisError) {
                  return _buildErrorState(state.message);
                }

                if (_stats == null) {
                  return _buildLoadingState();
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainStatCard(_stats!),
                      const SizedBox(height: 24),
                      if (_seasonStats != null) ...[
                        _buildSeasonStats(_seasonStats!),
                        const SizedBox(height: 24),
                      ],
                      _buildMatchHistory(_stats!),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatCard(MatchupStats stats) {
    final percentage = stats.bothScored6PlusPercentage;
    final color = ColorUtils.getProbabilityColor(percentage);
    final gradient = _getGradientForPercentage(percentage);

    return AnimatedBuilder(
      animation: _percentageAnimation,
      builder: (context, child) {
        final animatedPercentage = percentage * _percentageAnimation.value;
        return AnimatedGradientCard(
          gradient: gradient,
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Обе команды забили 6+',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0, end: animatedPercentage),
                builder: (context, value, child) {
                  return Text(
                    '${value.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${stats.bothScored6Plus} из ${stats.totalMatches} матчей',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 12,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    tween: Tween(begin: 0, end: percentage / 100),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeasonStats(List<SeasonStats> seasonStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Статистика по сезонам',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (seasonStats.isEmpty)
          const Center(
            child: Text(
              'Нет данных по сезонам',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          )
        else
          ...List.generate(seasonStats.length, (index) {
            final season = seasonStats[index];
            final gradient = _getGradientForPercentage(season.percentage);

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '${season.season}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сезон ${season.season}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${season.bothScored6Plus} из ${season.totalMatches} матчей',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${season.percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildMatchHistory(MatchupStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(
                Icons.history_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'История матчей',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(stats.matches.length, (index) {
          final match = stats.matches[index];
          final bothScored6 =
              match.bothTeamsScored(AppConstants.highScoringThreshold);
          final matchColor = bothScored6 ? AppTheme.accentGreen : AppTheme.textSecondary;

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + (index * 80)),
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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: matchColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      bothScored6
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: matchColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${match.homeScore} : ${match.awayScore}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMMM yyyy', 'ru').format(match.date),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${match.totalGoals} ⚽',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            PulseAnimation(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Анализируем данные...',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppTheme.dangerGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ошибка анализа',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradientForPercentage(double percentage) {
    if (percentage >= AppConstants.highProbabilityThreshold) {
      return AppTheme.successGradient;
    } else if (percentage >= AppConstants.mediumProbabilityThreshold) {
      return AppTheme.warningGradient;
    } else {
      return AppTheme.dangerGradient;
    }
  }
}
