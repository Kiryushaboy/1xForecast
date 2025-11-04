import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/matchup.dart';
import 'home_matchups_list.dart';

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
        Padding(
          padding: const EdgeInsets.only(
            left: UiConstants.spacingXSmall,
            bottom: UiConstants.spacingLarge,
            top: UiConstants.spacingSmall,
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
