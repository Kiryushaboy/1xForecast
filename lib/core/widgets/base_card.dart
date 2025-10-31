import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/ui_constants.dart';

/// Базовый класс для всех карточек в приложении
abstract class BaseCard extends StatelessWidget {
  final Gradient? gradient;
  final Color? shadowColor;
  final VoidCallback? onTap;
  final double? padding;
  final double? borderRadius;

  const BaseCard({
    super.key,
    this.gradient,
    this.shadowColor,
    this.onTap,
    this.padding,
    this.borderRadius,
  });

  /// Метод для построения содержимого карточки (должен быть переопределен)
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final effectivePadding = padding ??
        (isMobile
            ? UiConstants.cardPaddingLarge
            : UiConstants.cardPaddingXLarge);
    final effectiveBorderRadius =
        borderRadius ?? UiConstants.borderRadiusXLarge;

    final card = Container(
      padding: EdgeInsets.all(effectivePadding),
      decoration: BoxDecoration(
        gradient: gradient ?? _defaultGradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? _defaultShadowColor)
                .withOpacity(UiConstants.opacityLow),
            blurRadius: UiConstants.elevationXXHigh,
            offset: const Offset(0, UiConstants.elevationMedium),
          ),
        ],
      ),
      child: buildContent(context),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: card,
      );
    }

    return card;
  }

  Gradient get _defaultGradient => const LinearGradient(
        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  Color get _defaultShadowColor => const Color(0xFF4facfe);
}
