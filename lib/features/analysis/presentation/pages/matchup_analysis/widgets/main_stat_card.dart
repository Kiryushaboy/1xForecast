import 'package:flutter/material.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/services/percentage_color_service.dart';
import '../../../../../../core/widgets/widgets.dart';
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
    final gradient = PercentageColorService.getGradient(percentage);

    return GlassmorphicCard(
      accentColor: color,
      child: Column(
        children: [
          // Заголовок с иконкой
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: UiConstants.spacingMedium),
          Text(
            'Обе команды забили 6+',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.getTextPrimary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UiConstants.spacingLarge),

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
              height: 8,
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
