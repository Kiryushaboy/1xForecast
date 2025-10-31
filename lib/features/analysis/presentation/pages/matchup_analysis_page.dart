import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/analysis_bloc.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/constants/app_constants.dart';
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

class _MatchupAnalysisPageState extends State<MatchupAnalysisPage> {
  MatchupStats? _stats;
  List<SeasonStats>? _seasonStats;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.homeTeam} vs ${widget.awayTeam}'),
      ),
      body: BlocConsumer<AnalysisBloc, AnalysisState>(
        listener: (context, state) {
          if (state is MatchupStatsLoaded) {
            setState(() {
              _stats = state.stats;
            });
          } else if (state is SeasonStatsLoaded) {
            setState(() {
              _seasonStats = state.stats;
            });
          }
        },
        builder: (context, state) {
          if (state is AnalysisLoading && _stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalysisError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Ошибка: ${state.message}'),
                ],
              ),
            );
          }

          if (_stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = _stats!;
          final percentage = stats.bothScored6PlusPercentage;
          final color = ColorUtils.getProbabilityColor(percentage);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main stat card
                Card(
                  elevation: 4,
                  color: color.withAlpha(25),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Обе команды забили 6+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${stats.bothScored6Plus} из ${stats.totalMatches} матчей',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Season stats
                if (_seasonStats != null) ...[
                  const Text(
                    'Статистика по сезонам',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_seasonStats!.isEmpty)
                    const Text('Нет данных по сезонам')
                  else
                    ...List.generate(_seasonStats!.length, (index) {
                      final season = _seasonStats![index];
                      final seasonColor =
                          ColorUtils.getProbabilityColor(season.percentage);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: seasonColor,
                            child: Text(
                              '${season.season}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('Сезон ${season.season}'),
                          subtitle: Text(
                            '${season.bothScored6Plus} из ${season.totalMatches} матчей',
                          ),
                          trailing: Text(
                            '${season.percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: seasonColor,
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                ],

                // Match history
                const Text(
                  'История матчей',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                for (var match in stats.matches) ...[
                  Builder(builder: (context) {
                    final bothScored6 = match
                        .bothTeamsScored(AppConstants.highScoringThreshold);
                    final matchColor = ColorUtils.getSuccessColor(bothScored6);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          bothScored6 ? Icons.check_circle : Icons.cancel,
                          color: matchColor,
                          size: 32,
                        ),
                        title: Text(
                          '${match.homeScore} : ${match.awayScore}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('dd.MM.yyyy').format(match.date),
                        ),
                        trailing: Text(
                          '${match.totalGoals} голов',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
