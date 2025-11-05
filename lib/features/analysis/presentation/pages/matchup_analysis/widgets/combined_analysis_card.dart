// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/services/percentage_color_service.dart';
import '../../../../../../core/services/recommendation_level_service.dart';
import '../../../../domain/entities/matchup_stats.dart';
import '../../../../../matches/domain/services/bet_analysis_service.dart';

/// Объединенная карточка с процентом и рекомендацией ставки
class CombinedAnalysisCard extends StatelessWidget {
  final MatchupStats stats;
  final Animation<double> percentageAnimation;
  final String homeTeam;
  final String awayTeam;

  const CombinedAnalysisCard({
    super.key,
    required this.stats,
    required this.percentageAnimation,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = stats.bothScored6PlusPercentage;
    final color = PercentageColorService.getColor(percentage);

    // Получаем все ставки
    final analysisService = BetAnalysisService();
    final allBets = analysisService.getAllBets(
      stats.matches,
      awayTeam, // team1 - гости
      homeTeam, // team2 - хозяева
    );

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
        border: Border.all(
          color: AppTheme.isDarkMode(context)
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (AppTheme.isDarkMode(context) ? Colors.black : Colors.black)
                .withOpacity(AppTheme.isDarkMode(context) ? 0.15 : 0.06),
            blurRadius: UiConstants.elevationXHigh,
            offset: const Offset(0, UiConstants.elevationLow),
          ),
        ],
      ),
      padding: const EdgeInsets.all(UiConstants.cardPaddingLarge),
      child: Column(
        children: [
          // ========== СЕКЦИЯ ПРОЦЕНТА ==========
          // Процент
          AnimatedBuilder(
            animation: percentageAnimation,
            builder: (context, child) {
              final animatedPercentage = percentage * percentageAnimation.value;
              return Text(
                '${animatedPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1,
                  letterSpacing: -2,
                ),
              );
            },
          ),
          const SizedBox(height: UiConstants.spacingMedium),

          // Счетчик матчей
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              '${stats.bothScored6Plus} из ${stats.totalMatches} матчей',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: UiConstants.spacingLarge),

          // Прогресс-бар
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: AnimatedBuilder(
                animation: percentageAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: (percentage / 100) * percentageAnimation.value,
                    backgroundColor: AppTheme.isDarkMode(context)
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  );
                },
              ),
            ),
          ),

          // ========== РАЗДЕЛИТЕЛЬ ==========
          const SizedBox(height: UiConstants.spacingXLarge),
          const Divider(
            color: AppTheme.primaryBlue,
            thickness: 2,
          ),
          const SizedBox(height: UiConstants.spacingLarge),

          // ========== СЕКЦИЯ РЕКОМЕНДАЦИИ ==========
          if (allBets.isEmpty)
            Container(
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
            )
          else
            _buildRecommendationContent(context, allBets),
        ],
      ),
    );
  }

  Widget _buildRecommendationContent(
      BuildContext context, List<BetRecommendation> allBets) {
    final bestBet = allBets.first;
    final color = RecommendationLevelService.getColor(bestBet.level);
    final text = RecommendationLevelService.getText(bestBet.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок рекомендации с иконкой
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                RecommendationLevelService.getIcon(bestBet.level),
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: UiConstants.spacingMedium),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConstants.spacingLarge),

        // Лучшая ставка
        Container(
          padding: const EdgeInsets.all(UiConstants.cardPaddingMedium),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.08),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Лучшая ставка',
                      style: TextStyle(
                        color: AppTheme.getTextSecondary(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bestBet.name,
                      style: TextStyle(
                        color: AppTheme.getTextPrimary(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiConstants.spacingMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${bestBet.probability.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'вероятность',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Детальная статистика
        if (allBets.length > 1) ...[
          const SizedBox(height: UiConstants.spacingLarge),
          const Divider(
            color: AppTheme.primaryBlue,
            thickness: 2,
          ),
          const SizedBox(height: UiConstants.spacingMedium),

          // Список остальных ставок
          ...allBets.skip(1).map((bet) => _buildBetItem(context, bet)),
        ],
      ],
    );
  }

  Widget _buildBetItem(BuildContext context, BetRecommendation bet) {
    final betColor = RecommendationLevelService.getColor(bet.level);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.getCard(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: betColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Иконка уровня
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: betColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              RecommendationLevelService.getIcon(bet.level),
              color: betColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Название ставки
          Expanded(
            child: Text(
              bet.name,
              style: TextStyle(
                color: AppTheme.getTextPrimary(context),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Процент
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: betColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: betColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${bet.probability.toStringAsFixed(1)}%',
              style: TextStyle(
                color: betColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
