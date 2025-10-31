import '../../../matches/domain/entities/match.dart';

class MatchupStats {
  final String _homeTeam;
  final String _awayTeam;
  final List<Match> _matches;
  final int _totalMatches;
  final int _bothScored6Plus;
  final double _bothScored6PlusPercentage;

  const MatchupStats({
    required String homeTeam,
    required String awayTeam,
    required List<Match> matches,
    required int totalMatches,
    required int bothScored6Plus,
    required double bothScored6PlusPercentage,
  })  : _homeTeam = homeTeam,
        _awayTeam = awayTeam,
        _matches = matches,
        _totalMatches = totalMatches,
        _bothScored6Plus = bothScored6Plus,
        _bothScored6PlusPercentage = bothScored6PlusPercentage;

  // Геттеры для доступа к приватным полям
  String get homeTeam => _homeTeam;
  String get awayTeam => _awayTeam;
  List<Match> get matches => List.unmodifiable(_matches);
  int get totalMatches => _totalMatches;
  int get bothScored6Plus => _bothScored6Plus;
  double get bothScored6PlusPercentage => _bothScored6PlusPercentage;

  factory MatchupStats.fromMatches({
    required String homeTeam,
    required String awayTeam,
    required List<Match> matches,
  }) {
    final bothScored6Plus = matches.where((m) => m.bothTeamsScored(6)).length;

    return MatchupStats(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      matches: matches,
      totalMatches: matches.length,
      bothScored6Plus: bothScored6Plus,
      bothScored6PlusPercentage:
          matches.isEmpty ? 0.0 : (bothScored6Plus / matches.length) * 100,
    );
  }
}

class SeasonStats {
  final int _season;
  final int _totalMatches;
  final int _bothScored6Plus;
  final double _percentage;

  const SeasonStats({
    required int season,
    required int totalMatches,
    required int bothScored6Plus,
    required double percentage,
  })  : _season = season,
        _totalMatches = totalMatches,
        _bothScored6Plus = bothScored6Plus,
        _percentage = percentage;

  // Геттеры для доступа к приватным полям
  int get season => _season;
  int get totalMatches => _totalMatches;
  int get bothScored6Plus => _bothScored6Plus;
  double get percentage => _percentage;
}
