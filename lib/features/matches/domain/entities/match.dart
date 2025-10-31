class Match {
  final String _homeTeam;
  final String _awayTeam;
  final int _homeScore;
  final int _awayScore;
  final DateTime _date;
  final String _tournament;

  const Match({
    required String homeTeam,
    required String awayTeam,
    required int homeScore,
    required int awayScore,
    required DateTime date,
    required String tournament,
  })  : _homeTeam = homeTeam,
        _awayTeam = awayTeam,
        _homeScore = homeScore,
        _awayScore = awayScore,
        _date = date,
        _tournament = tournament;

  // Геттеры для доступа к приватным полям
  String get homeTeam => _homeTeam;
  String get awayTeam => _awayTeam;
  int get homeScore => _homeScore;
  int get awayScore => _awayScore;
  DateTime get date => _date;
  String get tournament => _tournament;

  int get totalGoals => _homeScore + _awayScore;

  bool get isHighScoring => _homeScore >= 6 && _awayScore >= 6;

  bool bothTeamsScored(int threshold) =>
      _homeScore >= threshold && _awayScore >= threshold;

  Map<String, dynamic> toJson() {
    return {
      'homeTeam': _homeTeam,
      'awayTeam': _awayTeam,
      'homeScore': _homeScore,
      'awayScore': _awayScore,
      'date': _date.toIso8601String(),
      'tournament': _tournament,
    };
  }

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      homeTeam: json['homeTeam'] as String,
      awayTeam: json['awayTeam'] as String,
      homeScore: json['homeScore'] as int,
      awayScore: json['awayScore'] as int,
      date: DateTime.parse(json['date'] as String),
      tournament: json['tournament'] as String,
    );
  }

  Match copyWith({
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    DateTime? date,
    String? tournament,
  }) {
    return Match(
      homeTeam: homeTeam ?? _homeTeam,
      awayTeam: awayTeam ?? _awayTeam,
      homeScore: homeScore ?? _homeScore,
      awayScore: awayScore ?? _awayScore,
      date: date ?? _date,
      tournament: tournament ?? _tournament,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          _homeTeam == other._homeTeam &&
          _awayTeam == other._awayTeam &&
          _homeScore == other._homeScore &&
          _awayScore == other._awayScore &&
          _date == other._date &&
          _tournament == other._tournament;

  @override
  int get hashCode =>
      _homeTeam.hashCode ^
      _awayTeam.hashCode ^
      _homeScore.hashCode ^
      _awayScore.hashCode ^
      _date.hashCode ^
      _tournament.hashCode;
}
