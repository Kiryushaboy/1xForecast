import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Сервис для определения цветов и градиентов на основе процента вероятности
class PercentageColorService {
  /// Определяет цвет на основе процента
  static Color getColor(double percentage) {
    if (percentage >= AppConstants.highProbabilityThreshold) {
      return const Color(0xFF66bb6a); // Зелёный
    } else if (percentage >= AppConstants.mediumProbabilityThreshold) {
      return const Color(0xFFffa726); // Оранжевый
    } else {
      return const Color(0xFFf5576c); // Красный
    }
  }

  /// Определяет градиент на основе процента
  static LinearGradient getGradient(double percentage) {
    if (percentage >= AppConstants.highProbabilityThreshold) {
      return const LinearGradient(
        colors: [Color(0xFF66bb6a), Color(0xFF43a047)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (percentage >= AppConstants.mediumProbabilityThreshold) {
      return const LinearGradient(
        colors: [Color(0xFFffa726), Color(0xFFfb8c00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  /// Определяет текстовое описание уровня вероятности
  static String getLevel(double percentage) {
    if (percentage >= AppConstants.highProbabilityThreshold) {
      return 'Высокая';
    } else if (percentage >= AppConstants.mediumProbabilityThreshold) {
      return 'Средняя';
    } else {
      return 'Низкая';
    }
  }
}
