import 'package:logger/logger.dart';
import '../../../matches/domain/entities/match.dart';

class BetParserService {
  final Logger _logger;

  BetParserService({Logger? logger}) : _logger = logger ?? Logger();

  /// Fetch matches from 1xbet API (placeholder - not implemented)
  Future<List<Match>> fetchMatches() async {
    _logger.i('Fetching matches from API...');

    // TODO: Implement actual API fetching logic
    // For now, return test data
    return _generateTestData();
  }

  List<Match> _generateTestData() {
    final now = DateTime.now();

    // Liverpool vs Nottingham Forest - 13 matches
    final liverpoolNottingham = [
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 10)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 8,
        awayScore: 7,
        date: now.subtract(const Duration(days: 25)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 6,
        awayScore: 7,
        date: now.subtract(const Duration(days: 40)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 9,
        awayScore: 6,
        date: now.subtract(const Duration(days: 55)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 7,
        awayScore: 8,
        date: now.subtract(const Duration(days: 70)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 85)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 8,
        awayScore: 9,
        date: now.subtract(const Duration(days: 100)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 7,
        awayScore: 7,
        date: now.subtract(const Duration(days: 115)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 9,
        awayScore: 8,
        date: now.subtract(const Duration(days: 130)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 6,
        awayScore: 8,
        date: now.subtract(const Duration(days: 145)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 7,
        awayScore: 6,
        date: now.subtract(const Duration(days: 160)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 5,
        awayScore: 7,
        date: now.subtract(const Duration(days: 175)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Liverpool',
        awayTeam: 'Nottingham',
        homeScore: 8,
        awayScore: 6,
        date: now.subtract(const Duration(days: 190)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
    ];

    // Add more test matchups
    final otherMatches = [
      Match(
        homeTeam: 'Manchester City',
        awayTeam: 'Chelsea',
        homeScore: 7,
        awayScore: 5,
        date: now.subtract(const Duration(days: 5)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
      Match(
        homeTeam: 'Arsenal',
        awayTeam: 'Tottenham',
        homeScore: 6,
        awayScore: 6,
        date: now.subtract(const Duration(days: 8)),
        tournament: 'FIFA FC24 4x4 England Premier League',
      ),
    ];

    return [...liverpoolNottingham, ...otherMatches];
  }
}
