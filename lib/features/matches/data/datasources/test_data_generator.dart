import '../../domain/entities/match.dart';

/// Генератор тестовых данных для отладки и тестирования
class TestDataGenerator {
  /// Генерирует подробный набор тестовых матчей
  /// Включает различные сценарии для проверки всех порогов рекомендаций
  static List<Match> generateTestMatches() {
    final now = DateTime.now();
    final matches = <Match>[];

    // ============================================
    // 1. Манчестер Сити vs Ливерпуль
    // Сценарий: Очень высокая результативность (> 90% - подозрительно)
    // Обе команды стабильно забивают 7-8 голов
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 8,
        awayScore: 7,
        date: now.subtract(const Duration(days: 1)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 9,
        awayScore: 8,
        date: now.subtract(const Duration(days: 8)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 7,
        awayScore: 8,
        date: now.subtract(const Duration(days: 15)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 10,
        awayScore: 9,
        date: now.subtract(const Duration(days: 22)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 8,
        awayScore: 8,
        date: now.subtract(const Duration(days: 29)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 9,
        awayScore: 7,
        date: now.subtract(const Duration(days: 36)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 8,
        awayScore: 9,
        date: now.subtract(const Duration(days: 43)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 50)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 10,
        awayScore: 8,
        date: now.subtract(const Duration(days: 57)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 9,
        awayScore: 9,
        date: now.subtract(const Duration(days: 64)),
        tournament: 'FIFA FC24 4x4 England',
      ),
    ]);

    // ============================================
    // 2. Реал Мадрид vs Барселона
    // Сценарий: Хорошая результативность (65-90% - рекомендуется)
    // Стабильно обе забивают 6+, но не всегда
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 2)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 9)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 16)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 5,
        awayScore: 6,
        date: now.subtract(const Duration(days: 23)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 30)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 37)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 6,
        awayScore: 8,
        date: now.subtract(const Duration(days: 44)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 7,
        awayScore: 5,
        date: now.subtract(const Duration(days: 51)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 58)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Реал Мадрид',
        awayTeam: 'Барселона',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 65)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
    ]);

    // ============================================
    // 3. Бавария vs Боруссия Дортмунд
    // Сценарий: Средняя результативность (~70% - рекомендуется)
    // Чаще обе забивают 6+, иногда нет
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 3)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 10)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 5,
        awayScore: 5,
        date: now.subtract(const Duration(days: 17)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 24)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 31)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 38)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 4,
        awayScore: 6,
        date: now.subtract(const Duration(days: 45)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 6,
        awayScore: 8,
        date: now.subtract(const Duration(days: 52)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 7,
        awayScore: 5,
        date: now.subtract(const Duration(days: 59)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
      Match(
        homeTeam: 'Бавария',
        awayTeam: 'Боруссия Дортмунд',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 66)),
        tournament: 'FIFA FC24 4x4 Germany',
      ),
    ]);

    // ============================================
    // 4. ПСЖ vs Марсель
    // Сценарий: Низкая результативность (< 65% - не рекомендуется)
    // Редко обе забивают 6+
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 5,
        awayScore: 4,
        date: now.subtract(const Duration(days: 4)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 6,
        awayScore: 3,
        date: now.subtract(const Duration(days: 11)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 4,
        awayScore: 5,
        date: now.subtract(const Duration(days: 18)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 25)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 5,
        awayScore: 5,
        date: now.subtract(const Duration(days: 32)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 3,
        awayScore: 4,
        date: now.subtract(const Duration(days: 39)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 46)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 4,
        awayScore: 6,
        date: now.subtract(const Duration(days: 53)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 5,
        awayScore: 3,
        date: now.subtract(const Duration(days: 60)),
        tournament: 'FIFA FC24 4x4 France',
      ),
      Match(
        homeTeam: 'ПСЖ',
        awayTeam: 'Марсель',
        homeScore: 6,
        awayScore: 5,
        date: now.subtract(const Duration(days: 67)),
        tournament: 'FIFA FC24 4x4 France',
      ),
    ]);

    // ============================================
    // 5. Ювентус vs Интер
    // Сценарий: Граничный случай (~65% - на границе)
    // Проверка точности порогов
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 5)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 7,
        awayScore: 5,
        date: now.subtract(const Duration(days: 12)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 5,
        awayScore: 6,
        date: now.subtract(const Duration(days: 19)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 26)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 4,
        awayScore: 5,
        date: now.subtract(const Duration(days: 33)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 40)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 5,
        awayScore: 5,
        date: now.subtract(const Duration(days: 47)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 54)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 61)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
      Match(
        homeTeam: 'Ювентус',
        awayTeam: 'Интер',
        homeScore: 5,
        awayScore: 7,
        date: now.subtract(const Duration(days: 68)),
        tournament: 'FIFA FC24 4x4 Italy',
      ),
    ]);

    // ============================================
    // 6. Челси vs Арсенал
    // Сценарий: Высокая результативность (~85% - рекомендуется)
    // Стабильно хороший показатель
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 6)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 13)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 20)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 27)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 34)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 5,
        awayScore: 6,
        date: now.subtract(const Duration(days: 41)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 8,
        awayScore: 7,
        date: now.subtract(const Duration(days: 48)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 6,
        awayScore: 8,
        date: now.subtract(const Duration(days: 55)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 62)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 69)),
        tournament: 'FIFA FC24 4x4 England',
      ),
    ]);

    // ============================================
    // 7. Атлетико Мадрид vs Севилья
    // Сценарий: Очень низкая результативность (~20% - не рекомендуется)
    // Оборонительная игра
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 3,
        awayScore: 4,
        date: now.subtract(const Duration(days: 7)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 5,
        awayScore: 3,
        date: now.subtract(const Duration(days: 14)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 4,
        awayScore: 4,
        date: now.subtract(const Duration(days: 21)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 28)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 3,
        awayScore: 5,
        date: now.subtract(const Duration(days: 35)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 4,
        awayScore: 3,
        date: now.subtract(const Duration(days: 42)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 5,
        awayScore: 4,
        date: now.subtract(const Duration(days: 49)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 6,
        awayScore: 5,
        date: now.subtract(const Duration(days: 56)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 4,
        awayScore: 5,
        date: now.subtract(const Duration(days: 63)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
      Match(
        homeTeam: 'Атлетико Мадрид',
        awayTeam: 'Севилья',
        homeScore: 3,
        awayScore: 3,
        date: now.subtract(const Duration(days: 70)),
        tournament: 'FIFA FC24 4x4 Spain',
      ),
    ]);

    // ============================================
    // 8. Манчестер Юнайтед vs Тоттенхэм
    // Сценарий: Граничный случай (~90% - на границе подозрительного)
    // Проверка верхнего порога
    // ============================================
    matches.addAll([
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 8,
        awayScore: 7,
        date: now.subtract(const Duration(days: 2)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 9)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 16)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 23)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 30)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 6,
        awayScore: 8,
        date: now.subtract(const Duration(days: 37)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 44)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 5,
        awayScore: 6,
        date: now.subtract(const Duration(days: 51)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 8,
        awayScore: 7,
        date: now.subtract(const Duration(days: 58)),
        tournament: 'FIFA FC24 4x4 England',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 65)),
        tournament: 'FIFA FC24 4x4 England',
      ),
    ]);

    return matches;
  }

  /// Возвращает статистику по сгенерированным данным
  static String getTestDataSummary() {
    return '''
📊 Тестовые данные:

1. ⚠️ Манчестер Сити vs Ливерпуль (10 матчей)
   - Вероятность: ~100% (обе 6+)
   - Ожидаемый результат: "Слишком подозрительно" (оранжевый)
   
2. ✅ Реал Мадрид vs Барселона (10 матчей)  
   - Вероятность: ~80% (обе 6+)
   - Ожидаемый результат: "Рекомендуется" (зелёный)
   
3. ✅ Бавария vs Боруссия Дортмунд (10 матчей)
   - Вероятность: ~70% (обе 6+)
   - Ожидаемый результат: "Рекомендуется" (зелёный)
   
4. ❌ ПСЖ vs Марсель (10 матчей)
   - Вероятность: ~30% (обе 6+)
   - Ожидаемый результат: "Не рекомендуется" (красный)
   
5. 🔄 Ювентус vs Интер (10 матчей)
   - Вероятность: ~60-70% (обе 6+)
   - Ожидаемый результат: граница "Не рекомендуется/Рекомендуется"
   
6. ✅ Челси vs Арсенал (10 матчей)
   - Вероятность: ~80-90% (обе 6+)
   - Ожидаемый результат: "Рекомендуется" (зелёный)
   
7. ❌ Атлетико Мадрид vs Севилья (10 матчей)
   - Вероятность: ~20% (обе 6+)
   - Ожидаемый результат: "Не рекомендуется" (красный)
   
8. 🔄 Манчестер Юнайтед vs Тоттенхэм (10 матчей)
   - Вероятность: ~90% (обе 6+)
   - Ожидаемый результат: граница "Рекомендуется/Подозрительно"

Всего: 80 матчей, 8 противостояний
''';
  }
}
