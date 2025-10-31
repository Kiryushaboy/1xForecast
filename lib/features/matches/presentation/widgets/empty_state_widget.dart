import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;

  const EmptyStateWidget({
    super.key,
    this.title = 'Нет данных',
    this.message = 'Загрузите матчи для начала работы',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.all(UiConstants.spacingHuge),
            decoration: BoxDecoration(
              gradient: AppTheme.warningGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentOrange.withOpacity(0.3),
                  blurRadius: UiConstants.elevationHuge,
                  offset: const Offset(0, UiConstants.elevationHigh),
                ),
              ],
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: UiConstants.spacingXXLarge),
          Text(
            title,
            style: TextStyle(
              fontSize: UiConstants.fontSizeXXLarge + 2,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: UiConstants.spacingSmall),
          Text(
            message,
            style: TextStyle(
              fontSize: UiConstants.fontSizeMedium + 1,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
