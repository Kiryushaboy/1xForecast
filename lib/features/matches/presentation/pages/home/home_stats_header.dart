import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../widgets/stats_card.dart';

/// Заголовок со статистикой
class HomeStatsHeader extends StatelessWidget {
  final int matchupsCount;
  final int totalMatches;

  const HomeStatsHeader({
    super.key,
    required this.matchupsCount,
    required this.totalMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatsCard(
          icon: Icons.group_rounded,
          value: matchupsCount,
          label: 'Команд',
          gradient: AppTheme.primaryGradient,
          shadowColor: AppTheme.primaryBlue,
        ),
        SizedBox(
          width: context.isMobile
              ? UiConstants.spacingMedium
              : UiConstants.spacingLarge,
        ),
        StatsCard(
          icon: Icons.sports_soccer_rounded,
          value: totalMatches,
          label: 'Матчей',
          gradient: AppTheme.successGradient,
          shadowColor: AppTheme.accentGreen,
        ),
      ],
    );
  }
}
