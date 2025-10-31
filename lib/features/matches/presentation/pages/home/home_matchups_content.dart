import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/matchup.dart';
import 'home_matchups_list.dart';
import 'home_stats_header.dart';

/// Основной контент с матчами
class HomeMatchupsContent extends StatelessWidget {
  final List<Matchup> matchups;
  final int totalMatches;

  const HomeMatchupsContent({
    super.key,
    required this.matchups,
    required this.totalMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeStatsHeader(
          matchupsCount: matchups.length,
          totalMatches: totalMatches,
        ),
        SizedBox(
          height: context.isMobile
              ? UiConstants.spacingXXLarge
              : UiConstants.spacingHuge,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: UiConstants.spacingXSmall,
            bottom: UiConstants.spacingLarge,
          ),
          child: Text(
            'Противостояния',
            style: TextStyle(
              fontSize: context.isMobile
                  ? UiConstants.fontSizeXLarge
                  : UiConstants.fontSizeXXLarge,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: UiConstants.letterSpacingNormal,
            ),
          ),
        ),
        HomeMatchupsList(matchups: matchups),
      ],
    );
  }
}
