import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Gradient gradient;
  final Color shadowColor;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(
          isMobile ? UiConstants.cardPaddingLarge : UiConstants.cardPaddingXLarge,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: UiConstants.elevationXXHigh,
              offset: const Offset(0, UiConstants.elevationMedium),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(UiConstants.spacingMedium),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
              ),
              child: Icon(
                icon,
                size: isMobile ? UiConstants.iconSizeLarge : UiConstants.iconSizeXLarge,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: isMobile ? UiConstants.spacingMedium : UiConstants.spacingLarge,
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: isMobile ? UiConstants.fontSizeHuge : UiConstants.fontSizeGiant,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            ),
            SizedBox(
              height: isMobile ? UiConstants.spacingXSmall : UiConstants.spacingSmall,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? UiConstants.fontSizeMedium : UiConstants.fontSizeMedium,
                color: Colors.white.withOpacity(UiConstants.opacityHigh),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
