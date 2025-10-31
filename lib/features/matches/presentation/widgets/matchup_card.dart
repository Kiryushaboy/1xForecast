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
        children: [
          _buildBadge(),
          SizedBox(width: UiConstants.spacingLarge),
          Expanded(child: _buildTeamInfo(context)),
          _buildArrowIcon(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: UiConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
        boxShadow: [
          BoxShadow(
            color: (AppTheme.isDarkMode(context) ? Colors.black : Colors.black)
                .withOpacity(AppTheme.isDarkMode(context) ? 0.15 : 0.06),
            blurRadius: UiConstants.elevationXHigh,
            offset: Offset(0, UiConstants.elevationLow),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
          child: Padding(
            padding: EdgeInsets.all(UiConstants.cardPaddingMedium),
            child: buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      width: UiConstants.badgeSizeMedium,
      height: UiConstants.badgeSizeMedium,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
      ),
      child: Center(
        child: Text(
          '$matchCount',
          style: const TextStyle(
            fontSize: UiConstants.fontSizeXXLarge,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          homeTeam,
          style: TextStyle(
            fontSize: UiConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.getTextPrimary(context),
            letterSpacing: UiConstants.letterSpacingTight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: UiConstants.spacingSmall - 2),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UiConstants.spacingSmall,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: AppTheme.getTextSecondary(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(UiConstants.borderRadiusSmall),
              ),
              child: Text(
                'VS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextSecondary(context),
                  letterSpacing: UiConstants.letterSpacingWide,
                ),
              ),
            ),
            const SizedBox(width: UiConstants.spacingSmall),
            Expanded(
              child: Text(
                awayTeam,
                style: TextStyle(
                  fontSize: UiConstants.fontSizeRegular,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimary(context),
                  letterSpacing: UiConstants.letterSpacingTight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusMedium),
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: UiConstants.iconSizeSmall,
        color: AppTheme.primaryBlue,
      ),
    );
  }
}
