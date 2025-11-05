import 'package:flutter/material.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/recommendation_level_service.dart';
import '../../domain/services/bet_analysis_service.dart';

class BetRecommendationWidget extends StatelessWidget {
  final BetRecommendation recommendation;

  const BetRecommendationWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final color = RecommendationLevelService.getColor(recommendation.level);
    final text = RecommendationLevelService.getText(recommendation.level);

    return Container(
      margin: const EdgeInsets.only(top: UiConstants.spacingMedium),
      padding: const EdgeInsets.all(UiConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusMedium),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              RecommendationLevelService.getIcon(recommendation.level),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: UiConstants.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${recommendation.probability.toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
