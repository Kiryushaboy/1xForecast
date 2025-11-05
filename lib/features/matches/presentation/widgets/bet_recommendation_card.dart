// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/recommendation_level_service.dart';
import '../../domain/services/bet_analysis_service.dart';

class BetRecommendationCard extends StatelessWidget {
  final List<BetRecommendation> allBets;

  const BetRecommendationCard({
    super.key,
    required this.allBets,
  });

  @override
  Widget build(BuildContext context) {
    if (allBets.isEmpty) {
      return const SizedBox.shrink();
    }

    final bestBet = allBets.first;
    final color = RecommendationLevelService.getColor(bestBet.level);
    final text = RecommendationLevelService.getText(bestBet.level);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Рекомендация ставки',
                      style: TextStyle(
                        color: AppTheme.getTextSecondary(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConstants.spacingLarge),

          // Лучшая ставка (крупно)
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
              borderRadius:
                  BorderRadius.circular(UiConstants.borderRadiusMedium),
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

          // Разделитель перед детальной статистикой
          if (allBets.length > 1) ...[
            const SizedBox(height: UiConstants.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppTheme.getTextSecondary(context).withOpacity(0.2),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Детальная статистика',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppTheme.getTextSecondary(context).withOpacity(0.2),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: UiConstants.spacingMedium),

            // Список всех остальных ставок
            ...allBets.skip(1).map((bet) => _buildBetItem(context, bet)),
          ],
        ],
      ),
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
