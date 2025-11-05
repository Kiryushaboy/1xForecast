import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/ui_constants.dart';

/// Универсальная карточка с эффектом glassmorphism
/// Используется вместо повторяющейся структуры Container + BoxDecoration + ClipRRect + BackdropFilter
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final Gradient? gradient;
  final double? blur;
  final double? borderRadius;
  final EdgeInsets? padding;

  const GlassmorphicCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.gradient,
    this.blur,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? UiConstants.borderRadiusXLarge;
    final effectiveBlur = blur ?? 10.0;
    final effectivePadding =
        padding ?? const EdgeInsets.all(UiConstants.cardPaddingLarge);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: AppTheme.isDarkMode(context)
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(gradient != null ? 0.2 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
          child: Container(
            padding: effectivePadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.1),
                  accentColor.withOpacity(0.05),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
