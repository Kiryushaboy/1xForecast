import 'package:hive/hive.dart';
import '../../domain/entities/match.dart';
import '../../../../core/constants/app_constants.dart';

class MatchLocalDataSource {
  static const String _boxName = AppConstants.matchesKey;
  Box<dynamic>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  Future<List<Match>> getMatches() async {
    await init();
    final data = _box!.get('matches', defaultValue: <dynamic>[]) as List;
    return data
        .map((json) => Match.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveMatches(List<Match> matches) async {
    await init();
    final jsonList = matches.map((m) => m.toJson()).toList();
    await _box!.put('matches', jsonList);
  }

  Future<void> addMatch(Match match) async {
    final matches = await getMatches();
    matches.add(match);
    await saveMatches(matches);
  }

  Future<void> clearMatches() async {
    await init();
    await _box!.delete('matches');
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
