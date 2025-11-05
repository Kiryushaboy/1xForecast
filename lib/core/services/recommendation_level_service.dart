import 'package:flutter/material.dart';
import '../../features/matches/domain/services/bet_analysis_service.dart';

/// Сервис для работы с уровнями рекомендаций ставок
class RecommendationLevelService {
  /// Определяет цвет на основе уровня рекомендации
  static Color getColor(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return const Color(0xFFf5576c); // Красный - не рекомендуется
      case RecommendationLevel.medium:
        return const Color(0xFF66bb6a); // Зелёный - рекомендуется (65-90%)
      case RecommendationLevel.recommended:
        return const Color(0xFFffa726); // Оранжевый - подозрительно (>90%)
    }
  }

  /// Определяет градиент на основе уровня рекомендации
  static LinearGradient getGradient(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return const LinearGradient(
          colors: [Color(0xFFef5350), Color(0xFFd32f2f)], // Красный градиент
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecommendationLevel.medium:
        return const LinearGradient(
          colors: [
            Color(0xFF66bb6a),
            Color(0xFF43a047)
          ], // Зелёный для рекомендуемых
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecommendationLevel.recommended:
        return const LinearGradient(
          colors: [
            Color(0xFFffa726),
            Color(0xFFfb8c00)
          ], // Оранжевый для подозрительных
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
        return 'Рекомендуется'; // 65-90%
      case RecommendationLevel.recommended:
        return 'Слишком подозрительно (на тесте)'; // >90%
    }
  }

  /// Определяет иконку на основе уровня рекомендации
  static IconData getIcon(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.notRecommended:
        return Icons.thumb_down_rounded; // Не рекомендуется
      case RecommendationLevel.medium:
        return Icons.thumb_up_rounded; // Рекомендуется (65-90%)
      case RecommendationLevel.recommended:
        return Icons.warning_amber_rounded; // Подозрительно (>90%)
    }
  }
}
