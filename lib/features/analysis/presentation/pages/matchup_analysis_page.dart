// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/analysis_bloc.dart';
import '../../domain/entities/matchup_stats.dart';
import 'matchup_analysis/widgets/analysis_app_bar.dart';
import 'matchup_analysis/widgets/analysis_states.dart';
import 'matchup_analysis/widgets/combined_analysis_card.dart';
import 'matchup_analysis/widgets/match_history_list.dart';

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
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar с названиями команд
          AnalysisAppBar(
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
          ),

          // Контент страницы
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        // Объединённая карточка с процентом и рекомендацией
                        CombinedAnalysisCard(
                          stats: _stats!,
                          percentageAnimation: _percentageAnimation,
                          homeTeam: widget.homeTeam,
                          awayTeam: widget.awayTeam,
                        ),
                        const SizedBox(height: 24),
                        // История матчей за последние 30 дней
                        MatchHistoryList(
                          matches: _stats!.matches,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Плавающая кнопка назад внизу экрана
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
