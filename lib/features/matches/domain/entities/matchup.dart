import 'package:equatable/equatable.dart';

/// Модель противостояния команд
class Matchup extends Equatable {
  final String _homeTeam;
  final String _awayTeam;
  final int _matchCount;

  const Matchup({
    required String homeTeam,
    required String awayTeam,
    required int matchCount,
  })  : _homeTeam = homeTeam,
        _awayTeam = awayTeam,
        _matchCount = matchCount;

  // Геттеры для доступа к приватным полям
  String get homeTeam => _homeTeam;
  String get awayTeam => _awayTeam;
  int get matchCount => _matchCount;

  String get key => '$_homeTeam vs $_awayTeam';

  @override
  List<Object?> get props => [_homeTeam, _awayTeam, _matchCount];

  @override
  String toString() => 'Matchup($_homeTeam vs $_awayTeam: $_matchCount матчей)';
}
