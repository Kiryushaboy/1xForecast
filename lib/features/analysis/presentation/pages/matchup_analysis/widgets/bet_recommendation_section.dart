import 'package:flutter/material.dart';
import '../../../../domain/entities/matchup_stats.dart';
import '../../../../../matches/domain/services/bet_analysis_service.dart';
import '../../../../../matches/presentation/widgets/bet_recommendation_card.dart';

/// Виджет рекомендации ставки
class BetRecommendationSection extends StatelessWidget {
  final MatchupStats stats;
  final String homeTeam;
  final String awayTeam;

  const BetRecommendationSection({
    super.key,
    required this.stats,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    final matches = stats.matches;

    // Отладка - показываем сколько матчей
    debugPrint('=== BET RECOMMENDATION DEBUG ===');
    debugPrint('Home: $homeTeam, Away: $awayTeam');
    debugPrint('Matches count: ${matches.length}');

    if (matches.isEmpty) {
      // Показываем сообщение если нет данных
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Недостаточно данных для анализа ставок',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Используем сервис анализа
    final analysisService = BetAnalysisService();
    final recommendation = analysisService.analyzeBestBet(
      matches,
      awayTeam, // team1 - гости
      homeTeam, // team2 - хозяева
    );

    debugPrint('Recommendation: ${recommendation.name}');
    debugPrint('Probability: ${recommendation.probability}%');
    debugPrint('================================');

    return BetRecommendationCard(recommendation: recommendation);
  }
}
