// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/services/percentage_color_service.dart';
import '../../../../domain/entities/matchup_stats.dart';

/// Карточка с главной статистикой "Обе команды забили 6+"
class MainStatCard extends StatelessWidget {
  final MatchupStats stats;
  final Animation<double> percentageAnimation;

  const MainStatCard({
    super.key,
    required this.stats,
    required this.percentageAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = stats.bothScored6PlusPercentage;
    final color = PercentageColorService.getColor(percentage);

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
          // Заголовок
          Text(
            'Обе команды забили 6+',
            style: TextStyle(
              color: AppTheme.getTextSecondary(context),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.spacingMedium),

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
        ],
      ),
    );
  }
}
