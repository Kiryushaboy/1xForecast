import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_theme.dart';

/// FAB для загрузки данных
class HomeLoadDataFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeLoadDataFAB({
    super.key,
    required this.onPressed,
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
            offset: Offset(0, UiConstants.elevationHigh),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(Icons.download_rounded, size: UiConstants.fontSizeXXLarge),
        label: Text(
          'Загрузить',
          style: TextStyle(
            fontSize: UiConstants.fontSizeRegular,
            fontWeight: FontWeight.w600,
            letterSpacing: UiConstants.letterSpacingNormal,
          ),
        ),
      ),
    );
  }
}
