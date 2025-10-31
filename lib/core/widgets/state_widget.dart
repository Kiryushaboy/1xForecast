import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/ui_constants.dart';
import '../widgets/animated_widgets.dart';

enum StateType { loading, error, empty }

/// Универсальный виджет для отображения состояний (loading, error, empty)
class StateWidget extends StatelessWidget {
  final StateType type;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Gradient? gradient;

  const StateWidget.loading({
    super.key,
    this.message = 'Загрузка данных...',
  })  : type = StateType.loading,
        onRetry = null,
        icon = Icons.sports_soccer,
        gradient = null;

  const StateWidget.error({
    super.key,
    required this.message,
    required this.onRetry,
  })  : type = StateType.error,
        icon = Icons.error_outline,
        gradient = null;

  const StateWidget.empty({
    super.key,
    this.message = 'Нет данных',
    String? title,
  })  : type = StateType.empty,
        onRetry = null,
        icon = Icons.inbox_outlined,
        gradient = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: EdgeInsets.all(UiConstants.spacingLarge),
        padding: EdgeInsets.all(
          AppTheme.isMobile(context)
              ? UiConstants.cardPaddingLarge
              : UiConstants.cardPaddingXLarge,
        ),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor().withOpacity(UiConstants.opacityLow),
              blurRadius: UiConstants.elevationXXHigh,
              offset: const Offset(0, UiConstants.elevationMedium),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == StateType.loading)
              PulseAnimation(
                child: _buildIcon(context),
              )
            else
              _buildIcon(context),
            SizedBox(height: UiConstants.spacingLarge),
            Text(
              message ?? _getDefaultMessage(),
              style: TextStyle(
                color: Colors.white.withOpacity(UiConstants.opacityHigh),
                fontSize: UiConstants.fontSizeMedium,
              ),
              textAlign: TextAlign.center,
            ),
            if (type == StateType.error && onRetry != null) ...[
              SizedBox(height: UiConstants.spacingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: UiConstants.spacingXLarge,
                    vertical: UiConstants.spacingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(UiConstants.borderRadiusLarge),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UiConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(UiConstants.opacityMedium),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusLarge),
      ),
      child: Icon(
        icon ?? Icons.info_outline,
        size: AppTheme.isMobile(context)
            ? UiConstants.iconSizeXLarge
            : UiConstants.iconSizeHuge,
        color: Colors.white,
      ),
    );
  }

  Gradient _getGradient() {
    switch (type) {
      case StateType.loading:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StateType.error:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StateType.empty:
        return const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getShadowColor() {
    switch (type) {
      case StateType.loading:
        return const Color(0xFF667eea);
      case StateType.error:
        return const Color(0xFFf5576c);
      case StateType.empty:
        return const Color(0xFFfa709a);
    }
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
