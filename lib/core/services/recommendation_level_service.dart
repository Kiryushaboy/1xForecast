import 'package:flutter/material.dart';
import '../../features/matches/domain/services/bet_analysis_service.dart';

/// Сервис для работы с уровнями рекомендаций ставок
class RecommendationLevelService {
  /// Определяет цвет на основе уровня рекомендации
  static Color getColor(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return const Color(0xFFf5576c); // Красный
      case RecommendationLevel.medium:
        return const Color(0xFFffa726); // Оранжевый
      case RecommendationLevel.recommended:
        return const Color(0xFF66bb6a); // Зелёный
    }
  }

  /// Определяет градиент на основе уровня рекомендации
  static LinearGradient getGradient(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecommendationLevel.medium:
        return const LinearGradient(
          colors: [Color(0xFFffa726), Color(0xFFfb8c00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecommendationLevel.recommended:
        return const LinearGradient(
          colors: [Color(0xFF66bb6a), Color(0xFF43a047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// Определяет текстовое описание уровня рекомендации
  static String getText(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return 'Не рекомендуется';
      case RecommendationLevel.medium:
        return 'Средняя вероятность';
      case RecommendationLevel.recommended:
        return 'Рекомендуется';
    }
  }

  /// Определяет иконку на основе уровня рекомендации
  static IconData getIcon(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return Icons.thumb_down_rounded;
      case RecommendationLevel.medium:
        return Icons.help_outline_rounded;
      case RecommendationLevel.recommended:
        return Icons.thumb_up_rounded;
    }
  }
}
