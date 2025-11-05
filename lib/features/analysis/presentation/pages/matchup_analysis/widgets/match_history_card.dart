import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../matches/domain/entities/match.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/constants/ui_constants.dart';

/// Виджет для отображения одного матча из истории
class MatchHistoryCard extends StatelessWidget {
  final Match match;

  const MatchHistoryCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yy');
    final formattedDate = dateFormat.format(match.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
        border: Border.all(
          color: AppTheme.isDarkMode(context)
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (AppTheme.isDarkMode(context) ? Colors.black : Colors.black)
                .withOpacity(AppTheme.isDarkMode(context) ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Дата
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: AppTheme.isDarkMode(context)
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formattedDate,
                style: TextStyle(
                  color: AppTheme.getTextSecondary(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Команды и счёт
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Хозяева
                  Row(
                    children: [
                      Icon(
                        Icons.home_rounded,
                        size: 14,
                        color: AppTheme.getTextSecondary(context),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          match.homeTeam,
                          style: TextStyle(
                            color: AppTheme.getTextPrimary(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildScoreBadge(context, match.homeScore),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Гости
                  Row(
                    children: [
                      Icon(
                        Icons.flight_rounded,
                        size: 14,
                        color: AppTheme.getTextSecondary(context),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          match.awayTeam,
                          style: TextStyle(
                            color: AppTheme.getTextPrimary(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildScoreBadge(context, match.awayScore),
                    ],
                  ),
                ],
              ),
            ),

            // Индикатор высокого счёта
            if (match.isHighScoring) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF66bb6a).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFF66bb6a),
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge(BuildContext context, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode(context)
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        score.toString(),
        style: TextStyle(
          color: AppTheme.getTextPrimary(context),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
