import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/widgets/widgets.dart';

class StatsCard extends BaseCard {
  final IconData icon;
  final int value;
  final String label;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required super.gradient,
    required super.shadowColor,
  });

  @override
  Widget buildContent(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(UiConstants.spacingMedium),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(UiConstants.opacityMedium),
              borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
            ),
            child: Icon(
              icon,
              size: isMobile
                  ? UiConstants.iconSizeLarge
                  : UiConstants.iconSizeXLarge,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height:
                isMobile ? UiConstants.spacingMedium : UiConstants.spacingLarge,
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: isMobile
                  ? UiConstants.fontSizeHuge
                  : UiConstants.fontSizeGiant,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
            ),
          ),
          SizedBox(
            height:
                isMobile ? UiConstants.spacingXSmall : UiConstants.spacingSmall,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: UiConstants.fontSizeMedium,
              color: Colors.white.withOpacity(UiConstants.opacityHigh),
            ),
          ),
        ],
      ),
    );
  }
}
