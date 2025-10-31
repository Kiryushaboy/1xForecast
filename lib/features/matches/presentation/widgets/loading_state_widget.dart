import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/widgets/animated_widgets.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;

  const LoadingStateWidget({
    super.key,
    this.message = 'Загрузка матчей...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          PulseAnimation(
            child: Container(
              padding: const EdgeInsets.all(UiConstants.cardPaddingXLarge),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: UiConstants.elevationHuge,
                    offset: const Offset(0, UiConstants.elevationHigh),
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: UiConstants.iconSizeXXLarge,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: UiConstants.spacingXXLarge),
          Text(
            message,
            style: TextStyle(
              fontSize: UiConstants.fontSizeLarge,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
