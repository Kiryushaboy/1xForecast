import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/analysis_providers.dart';
import '../../../matches/presentation/providers/match_providers.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/constants/app_constants.dart';

class MatchupAnalysisPage extends ConsumerWidget {
  final String homeTeam;
  final String awayTeam;

  const MatchupAnalysisPage({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = MatchupParams(homeTeam: homeTeam, awayTeam: awayTeam);
    final statsAsync = ref.watch(matchupStatsProvider(params));
    final seasonStatsAsync = ref.watch(seasonStatsProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: Text('$homeTeam vs $awayTeam'),
      ),
      body: statsAsync.when(
        data: (stats) {
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
                const Text(
                  'Статистика по сезонам',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                seasonStatsAsync.when(
                  data: (seasonStats) {
                    if (seasonStats.isEmpty) {
                      return const Text('Нет данных по сезонам');
                    }

                    return Column(
                      children: seasonStats.map((season) {
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
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Ошибка: $error'),
                ),
                const SizedBox(height: 24),

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: $error'),
            ],
          ),
        ),
      ),
    );
  }
}
