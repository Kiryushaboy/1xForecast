/// Сервис для получения URL логотипов команд
class TeamLogoService {
  /// Получить URL логотипа команды
  /// Использует прямые ссылки на качественные PNG логотипы с прозрачным фоном
  static String getTeamLogoUrl(String teamName) {
    // Нормализуем название команды для поиска
    final normalizedName = _normalizeTeamName(teamName);

    // Маппинг команд на прямые URL качественных PNG логотипов с прозрачным фоном
    // Используем API logo-football.com
    final teamLogos = {
      // Английские клубы
      'манчестер сити': 'https://media.api-sports.io/football/teams/50.png',
      'manchester city': 'https://media.api-sports.io/football/teams/50.png',
      'ливерпуль': 'https://media.api-sports.io/football/teams/40.png',
      'liverpool': 'https://media.api-sports.io/football/teams/40.png',
      'челси': 'https://media.api-sports.io/football/teams/49.png',
      'chelsea': 'https://media.api-sports.io/football/teams/49.png',
      'арсенал': 'https://media.api-sports.io/football/teams/42.png',
      'arsenal': 'https://media.api-sports.io/football/teams/42.png',
      'ман юнайтед': 'https://media.api-sports.io/football/teams/33.png',
      'manchester united': 'https://media.api-sports.io/football/teams/33.png',
      'man united': 'https://media.api-sports.io/football/teams/33.png',
      'тоттенхэм': 'https://media.api-sports.io/football/teams/47.png',
      'tottenham': 'https://media.api-sports.io/football/teams/47.png',

      // Испанские клубы
      'реал мадрид': 'https://media.api-sports.io/football/teams/541.png',
      'real madrid': 'https://media.api-sports.io/football/teams/541.png',
      'барселона': 'https://media.api-sports.io/football/teams/529.png',
      'barcelona': 'https://media.api-sports.io/football/teams/529.png',
      'атлетико': 'https://media.api-sports.io/football/teams/530.png',
      'atletico': 'https://media.api-sports.io/football/teams/530.png',
      'atletico madrid': 'https://media.api-sports.io/football/teams/530.png',

      // Немецкие клубы
      'бавария': 'https://media.api-sports.io/football/teams/157.png',
      'bayern': 'https://media.api-sports.io/football/teams/157.png',
      'bayern munich': 'https://media.api-sports.io/football/teams/157.png',
      'боруссия дортмунд': 'https://media.api-sports.io/football/teams/165.png',
      'borussia dortmund': 'https://media.api-sports.io/football/teams/165.png',
      'dortmund': 'https://media.api-sports.io/football/teams/165.png',

      // Французские клубы
      'псж': 'https://media.api-sports.io/football/teams/85.png',
      'psg': 'https://media.api-sports.io/football/teams/85.png',
      'paris saint-germain':
          'https://media.api-sports.io/football/teams/85.png',

      // Итальянские клубы
      'ювентус': 'https://media.api-sports.io/football/teams/496.png',
      'juventus': 'https://media.api-sports.io/football/teams/496.png',
      'интер': 'https://media.api-sports.io/football/teams/505.png',
      'inter': 'https://media.api-sports.io/football/teams/505.png',
      'милан': 'https://media.api-sports.io/football/teams/489.png',
      'milan': 'https://media.api-sports.io/football/teams/489.png',
      'ac milan': 'https://media.api-sports.io/football/teams/489.png',
      'наполи': 'https://media.api-sports.io/football/teams/492.png',
      'napoli': 'https://media.api-sports.io/football/teams/492.png',
    };

    final logoUrl = teamLogos[normalizedName];

    if (logoUrl != null) {
      return logoUrl;
    }

    // Если команда не найдена в маппинге, возвращаем пустую строку
    // В этом случае будет использоваться fallback иконка
    return '';
  }

  /// Нормализация названия команды для поиска
  static String _normalizeTeamName(String teamName) {
    return teamName.toLowerCase().trim();
  }

  /// Проверка, есть ли логотип для команды
  static bool hasLogo(String teamName) {
    return getTeamLogoUrl(teamName).isNotEmpty;
  }
}
