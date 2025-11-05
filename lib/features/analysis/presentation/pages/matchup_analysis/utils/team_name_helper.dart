/// Утилита для работы с названиями команд
class TeamNameHelper {
  /// Сокращает название команды, делая инициалы из последующих слов
  /// Пример: "Манчестер Юнайтед" → "Манчестер Ю."
  static String abbreviate(String teamName) {
    final words = teamName.split(' ');
    if (words.length <= 1) return teamName;

    // Оставляем первое слово полностью, остальные сокращаем до первой буквы
    final firstWord = words[0];
    final abbreviations = words.skip(1).map((word) => '${word[0]}.').join(' ');

    return '$firstWord $abbreviations';
  }
}
