// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/ui_constants.dart';

enum StateType { loading, error, empty }

/// Универсальный виджет для отображения состояний (loading, error, empty)
class StateWidget extends StatelessWidget {
  final StateType type;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const StateWidget.loading({
    super.key,
    this.message = 'Загрузка данных...',
  })  : type = StateType.loading,
        onRetry = null,
        icon = Icons.sports_soccer;

  const StateWidget.error({
    super.key,
    required this.message,
    required this.onRetry,
  })  : type = StateType.error,
        icon = Icons.error_outline;

  const StateWidget.empty({
    super.key,
    this.message = 'Нет данных',
    String? title,
  })  : type = StateType.empty,
        onRetry = null,
        icon = Icons.inbox_outlined;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: AppTheme.isMobile(context) ? double.infinity : 600,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: AppTheme.isMobile(context)
                ? UiConstants.spacingXLarge
                : UiConstants.spacingXLarge * 3,
            vertical: screenHeight * 0.15, // Центрируем по вертикали
          ),
          decoration: BoxDecoration(
            color: AppTheme.getCard(context),
            borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
            border: Border.all(
              color: AppTheme.isDarkMode(context)
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (AppTheme.isDarkMode(context)
                        ? Colors.black
                        : Colors.black)
                    .withOpacity(AppTheme.isDarkMode(context) ? 0.15 : 0.06),
                blurRadius: UiConstants.elevationXHigh,
                offset: const Offset(0, UiConstants.elevationLow),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.all(
                  AppTheme.isMobile(context)
                      ? UiConstants.cardPaddingXLarge * 1.5
                      : UiConstants.cardPaddingXLarge * 2,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryBlue.withOpacity(0.08),
                      AppTheme.primaryBlue.withOpacity(0.03),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (type == StateType.loading)
                      _buildLoadingAnimation()
                    else
                      _buildIcon(context),
                    SizedBox(
                        height: AppTheme.isMobile(context)
                            ? UiConstants.spacingXLarge * 1.5
                            : UiConstants.spacingXLarge * 2),
                    Text(
                      message ?? _getDefaultMessage(),
                      style: TextStyle(
                        color: AppTheme.getTextPrimary(context),
                        fontSize: AppTheme.isMobile(context) ? 26 : 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (type == StateType.error && onRetry != null) ...[
                      const SizedBox(height: UiConstants.spacingXLarge * 1.5),
                      _buildRetryButton(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return const _RotatingIcon();
  }

  Widget _buildIcon(BuildContext context) {
    final iconSize = AppTheme.isMobile(context) ? 100.0 : 120.0;
    final innerIconSize = AppTheme.isMobile(context) ? 50.0 : 60.0;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        gradient: type == StateType.error
            ? const LinearGradient(
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: (type == StateType.error
                    ? const Color(0xFFf5576c)
                    : AppTheme.primaryBlue)
                .withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon ?? Icons.info_outline,
        size: innerIconSize,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRetryButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UiConstants.spacingXLarge,
              vertical: UiConstants.spacingMedium,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Повторить',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDefaultMessage() {
    switch (type) {
      case StateType.loading:
        return 'Загрузка данных...';
      case StateType.error:
        return 'Произошла ошибка';
      case StateType.empty:
        return 'Нет данных';
    }
  }
}

class _RotatingIcon extends StatefulWidget {
  const _RotatingIcon();

  @override
  State<_RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<_RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = AppTheme.isMobile(context) ? 100.0 : 120.0;
    final innerIconSize = AppTheme.isMobile(context) ? 50.0 : 60.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 6.28319, // 2 * PI
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius:
                  BorderRadius.circular(UiConstants.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.sports_soccer,
              size: innerIconSize,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
