import 'package:flutter/material.dart';
import '../../../../../matches/domain/entities/match.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'match_history_card.dart';

/// Виджет для отображения истории матчей за последние 30 дней
class MatchHistoryList extends StatelessWidget {
  final List<Match> matches;

  const MatchHistoryList({
    super.key,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    // Фильтруем матчи за последние 30 дней
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final recentMatches = matches
        .where((match) => match.date.isAfter(thirtyDaysAgo))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // сортируем от новых к старым

    if (recentMatches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Счётчик матчей
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 40,
                color: AppTheme.primaryBlue,
              ),
              SizedBox(width: 10),
              Text(
                'История матчей',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Список матчей
        ...recentMatches.map((match) => MatchHistoryCard(match: match)),
      ],
    );
  }
}
