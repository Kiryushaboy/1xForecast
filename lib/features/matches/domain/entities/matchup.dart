import 'package:equatable/equatable.dart';

/// Модель противостояния команд
class Matchup extends Equatable {
  final String homeTeam;
  final String awayTeam;
  final int matchCount;

  const Matchup({
    required this.homeTeam,
    required this.awayTeam,
    required this.matchCount,
  });

  String get key => '$homeTeam vs $awayTeam';

  @override
  List<Object?> get props => [homeTeam, awayTeam, matchCount];

  @override
  String toString() => 'Matchup($homeTeam vs $awayTeam: $matchCount матчей)';
}
