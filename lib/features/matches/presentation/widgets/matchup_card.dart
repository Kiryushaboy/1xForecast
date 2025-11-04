// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/widgets/widgets.dart';

class MatchupCard extends BaseCard {
  final String homeTeam;
  final String awayTeam;
  final int matchCount;

  const MatchupCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchCount,
    required super.onTap,
  });

  @override
  Widget buildContent(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: UiConstants.animationDurationSlow,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, UiConstants.spacingXLarge * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTeamWithIcon(context, homeTeam, true),
          _buildVsBadge(),
          _buildTeamWithIcon(context, awayTeam, false),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UiConstants.spacingMedium),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConstants.cardPaddingMedium,
              vertical: UiConstants.cardPaddingMedium + 4,
            ),
            child: buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamWithIcon(
      BuildContext context, String teamName, bool isHome) {
    final words = teamName.split(' ');

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHome) ...[
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius:
                    BorderRadius.circular(UiConstants.borderRadiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.sports_soccer,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                words.join('\n'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextPrimary(context),
                  height: 1.3,
                ),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ] else ...[
            Expanded(
              child: Text(
                words.join('\n'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextPrimary(context),
                  height: 1.3,
                ),
                textAlign: TextAlign.right,
                softWrap: true,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius:
                    BorderRadius.circular(UiConstants.borderRadiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.sports_soccer,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
