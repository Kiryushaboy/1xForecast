import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.all(UiConstants.cardPaddingXLarge),
            decoration: BoxDecoration(
              gradient: AppTheme.dangerGradient,
              borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: UiConstants.iconSizeXXLarge,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: UiConstants.spacingXXLarge),
          Text(
            'Ошибка загрузки',
            style: TextStyle(
              fontSize: UiConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: UiConstants.spacingSmall),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiConstants.fontSizeMedium + 1,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: UiConstants.spacingXXLarge),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
