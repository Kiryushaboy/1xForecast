import 'package:equatable/equatable.dart';
import '../../../matches/domain/entities/match.dart';

class MatchupStats extends Equatable {
  final String homeTeam;
  final String awayTeam;
  final List<Match> matches;
  final int totalMatches;
  final int bothScored6Plus;
  final double bothScored6PlusPercentage;

  const MatchupStats({
    required this.homeTeam,
    required this.awayTeam,
    required this.matches,
    required this.totalMatches,
    required this.bothScored6Plus,
    required this.bothScored6PlusPercentage,
  });

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

  @override
  List<Object?> get props => [
        homeTeam,
        awayTeam,
        matches,
        totalMatches,
        bothScored6Plus,
        bothScored6PlusPercentage
      ];
}

class SeasonStats extends Equatable {
  final int season;
  final int totalMatches;
  final int bothScored6Plus;
  final double percentage;

  const SeasonStats({
    required this.season,
    required this.totalMatches,
    required this.bothScored6Plus,
    required this.percentage,
  });

  @override
  List<Object?> get props =>
      [season, totalMatches, bothScored6Plus, percentage];
}
