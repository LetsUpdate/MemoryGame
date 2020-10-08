import 'package:shared_preferences/shared_preferences.dart';

class ScoreSystem {
  int _fails = 0;
  int _successes = 0;
  Duration _averageTime = Duration();
  Duration _allTime = Duration();

  void addTime(Duration time) {
    _allTime =
        Duration(milliseconds: time.inMilliseconds + _allTime.inMilliseconds);
    _averageTime = _averageTime.inMilliseconds != 0
        ? new Duration(
            milliseconds:
                ((_averageTime.inMilliseconds + time.inMilliseconds) / 2)
                    .round())
        : time;
  }

  void raiseFails() {
    _fails++;
  }

  void raiseSuccesses() {
    _successes++;
  }

  int get fails {
    return _fails;
  }

  int get successes {
    return _successes;
  }

  Duration get averageTime {
    return _averageTime;
  }

  Duration get allTime {
    return _allTime;
  }

  String get winRate {
    return (_successes / _fails).toStringAsExponential(2);
  }

  Future<void> loadFromSave() async {
    final prefs = await SharedPreferences.getInstance();
    _fails = prefs.get('_fails') ?? 0;
    _successes = prefs.get('_successes') ?? 0;
    _averageTime = Duration(milliseconds: prefs.get('_averageTime') ?? 0);
    _allTime = Duration(milliseconds: prefs.get('_allTime') ?? 0);
  }

  Future<void> saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('_fails', _fails);
    prefs.setInt('_successes', _successes);
    prefs.setInt('_averageTime', _averageTime.inMilliseconds);
    prefs.setInt('_allTime', _allTime.inMilliseconds);
  }

  Future<void> clearStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return loadFromSave();
  }
}

final ScoreSystem scoreSystem = new ScoreSystem();
