// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Расширения для упрощенного доступа к теме через BuildContext
extension ThemeExtensions on BuildContext {
  /// Текущий ThemeData
  ThemeData get theme => Theme.of(this);

  /// Основной цвет темы
  Color get primaryColor => theme.primaryColor;

  /// Цвет фона
  Color get backgroundColor => isDark
      ? AppTheme.backgroundDark
      : AppTheme.backgroundLight;

  /// Цвет поверхности
  Color get surfaceColor => AppTheme.getSurface(this);

  /// Цвет карточки
  Color get cardColor => AppTheme.getCard(this);

  /// Основной текстовый цвет
  Color get textPrimary => AppTheme.getTextPrimary(this);

  /// Вторичный текстовый цвет
  Color get textSecondary => AppTheme.getTextSecondary(this);

  /// Тёмная тема активна?
  bool get isDark => AppTheme.isDarkMode(this);

  /// Светлая тема активна?
  bool get isLight => !isDark;

  /// Мобильное устройство?
  bool get isMobile => AppTheme.isMobile(this);

  /// Планшет?
  bool get isTablet => AppTheme.isTablet(this);

  /// Десктоп?
  bool get isDesktop => AppTheme.isDesktop(this);

  /// Горизонтальные отступы
  double get horizontalPadding => AppTheme.getHorizontalPadding(this);

  /// Количество колонок для сетки
  int get gridColumns => AppTheme.getGridColumns(this);

  /// Ширина экрана
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Высота экрана
  double get screenHeight => MediaQuery.of(this).size.height;
}

/// Расширения для TextStyle
extension TextStyleExtensions on TextStyle {
  /// Сделать текст жирным
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Сделать текст средней жирности
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Сделать текст обычным
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Установить прозрачность
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withOpacity(opacity));

  /// Установить размер шрифта
  TextStyle withSize(double size) => copyWith(fontSize: size);
}
