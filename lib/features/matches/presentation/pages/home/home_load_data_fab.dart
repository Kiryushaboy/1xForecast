import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_theme.dart';

/// FAB для загрузки данных
class HomeLoadDataFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const HomeLoadDataFAB({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusXXLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: UiConstants.elevationHuge,
            offset: const Offset(0, UiConstants.elevationHigh),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.download_rounded,
                size: UiConstants.fontSizeXXLarge),
        label: Text(
          isLoading ? 'Загрузка...' : 'Загрузить',
          style: const TextStyle(
            fontSize: UiConstants.fontSizeRegular,
            fontWeight: FontWeight.w600,
            letterSpacing: UiConstants.letterSpacingNormal,
          ),
        ),
      ),
    );
  }
}
