import '../../domain/entities/match.dart';

enum BetType {
  bothScore6Plus,
  team1Over6_5,
  team1Over7_5,
  team2Over6_5,
  team2Over7_5,
}

class BetRecommendation {
  final BetType type;
  final String name;
  final double probability;
  final RecommendationLevel level;

  BetRecommendation({
    required this.type,
    required this.name,
    required this.probability,
    required this.level,
  });
}

enum RecommendationLevel {
  notRecommended, // < 62%
  medium, // 62-75%
  recommended, // > 75%
}

class BetAnalysisService {
  /// Анализирует статистику матчей и возвращает лучшую ставку
  BetRecommendation analyzeBestBet(
      List<Match> matches, String team1, String team2) {
    if (matches.isEmpty) {
      return BetRecommendation(
        type: BetType.bothScore6Plus,
        name: 'Недостаточно данных',
        probability: 0,
        level: RecommendationLevel.notRecommended,
      );
    }

    final total = matches.length.toDouble();

    // a) Обе забьют по 6 и более
    final bothScore6Plus =
        matches.where((m) => m.homeScore >= 6 && m.awayScore >= 6).length /
            total *
            100;

    // b) ИТБ 6.5 - Первая команда (гости)
    final team1Over6_5 =
        matches.where((m) => m.awayScore >= 7).length / total * 100;

    // c) ИТБ 7.5 - Первая команда (гости)
    final team1Over7_5 =
        matches.where((m) => m.awayScore >= 8).length / total * 100;

    // d) ИТБ 6.5 - Вторая команда (хозяева)
    final team2Over6_5 =
        matches.where((m) => m.homeScore >= 7).length / total * 100;

    // e) ИТБ 7.5 - Вторая команда (хозяева)
    final team2Over7_5 =
        matches.where((m) => m.homeScore >= 8).length / total * 100;

    // Создаём список всех ставок
    final bets = [
      (BetType.bothScore6Plus, 'Обе забьют по 6+', bothScore6Plus),
      (BetType.team1Over6_5, 'ИТБ 6.5 $team1', team1Over6_5),
      (BetType.team1Over7_5, 'ИТБ 7.5 $team1', team1Over7_5),
      (BetType.team2Over6_5, 'ИТБ 6.5 $team2', team2Over6_5),
      (BetType.team2Over7_5, 'ИТБ 7.5 $team2', team2Over7_5),
    ];

    // Находим ставку с максимальной вероятностью
    final best = bets.reduce((a, b) => a.$3 > b.$3 ? a : b);

    return BetRecommendation(
      type: best.$1,
      name: best.$2,
      probability: best.$3,
      level: _getRecommendationLevel(best.$3),
    );
  }

  RecommendationLevel _getRecommendationLevel(double probability) {
    if (probability < 62) {
      return RecommendationLevel.notRecommended;
    } else if (probability <= 75) {
      return RecommendationLevel.medium;
    } else {
      return RecommendationLevel.recommended;
    }
  }

  /// Получить все метрики для детального отображения
  Map<String, double> getAllMetrics(List<Match> matches) {
    if (matches.isEmpty) {
      return {};
    }

    final total = matches.length.toDouble();

    return {
      'bothScore6Plus':
          matches.where((m) => m.homeScore >= 6 && m.awayScore >= 6).length /
              total *
              100,
      'team1Over6_5':
          matches.where((m) => m.awayScore >= 7).length / total * 100,
      'team1Over7_5':
          matches.where((m) => m.awayScore >= 8).length / total * 100,
      'team2Over6_5':
          matches.where((m) => m.homeScore >= 7).length / total * 100,
      'team2Over7_5':
          matches.where((m) => m.homeScore >= 8).length / total * 100,
    };
  }
}
