import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/analysis_bloc.dart';
import '../../domain/entities/matchup_stats.dart';
import 'matchup_analysis/widgets/analysis_app_bar.dart';
import 'matchup_analysis/widgets/analysis_states.dart';
import 'matchup_analysis/widgets/main_stat_card.dart';
import 'matchup_analysis/widgets/bet_recommendation_section.dart';

/// Страница детального анализа матча между двумя командами
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

    // Загружаем статистику
    context.read<AnalysisBloc>().add(
          LoadMatchupStats(
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
          // AppBar с названиями команд
          AnalysisAppBar(
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
          ),

          // Контент страницы
          SliverToBoxAdapter(
            child: BlocConsumer<AnalysisBloc, AnalysisState>(
              listener: (context, state) {
                if (state is MatchupStatsLoaded) {
                  setState(() {
                    _stats = state.stats;
                  });
                  _percentageController.forward();
                }
              },
              builder: (context, state) {
                // Состояние загрузки
                if (state is AnalysisLoading && _stats == null) {
                  return const AnalysisLoadingState();
                }

                // Состояние ошибки
                if (state is AnalysisError) {
                  return AnalysisErrorState(message: state.message);
                }

                // Показываем загрузку если данных еще нет
                if (_stats == null) {
                  return const AnalysisLoadingState();
                }

                // Основной контент
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Рекомендация ставки
                      BetRecommendationSection(
                        stats: _stats!,
                        homeTeam: widget.homeTeam,
                        awayTeam: widget.awayTeam,
                      ),
                      const SizedBox(height: 48),

                      // Основная статистика по центру
                      Center(
                        child: MainStatCard(
                          stats: _stats!,
                          percentageAnimation: _percentageAnimation,
                        ),
                      ),
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
}
