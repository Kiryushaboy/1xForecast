class Match {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime date;
  final String tournament;

  const Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.date,
    required this.tournament,
  });

  int get totalGoals => homeScore + awayScore;

  bool get isHighScoring => homeScore >= 6 && awayScore >= 6;

  bool bothTeamsScored(int threshold) =>
      homeScore >= threshold && awayScore >= threshold;

  Map<String, dynamic> toJson() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'date': date.toIso8601String(),
      'tournament': tournament,
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
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      date: date ?? this.date,
      tournament: tournament ?? this.tournament,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          homeTeam == other.homeTeam &&
          awayTeam == other.awayTeam &&
          homeScore == other.homeScore &&
          awayScore == other.awayScore &&
          date == other.date &&
          tournament == other.tournament;

  @override
  int get hashCode =>
      homeTeam.hashCode ^
      awayTeam.hashCode ^
      homeScore.hashCode ^
      awayScore.hashCode ^
      date.hashCode ^
      tournament.hashCode;
}
