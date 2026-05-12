import 'dart:math';

import '../models/player.dart';
import '../models/team_model.dart';
import '../models/formation.dart';

class MatchEngine {
  final Random rng = Random();

  int calculateTeamStrength(List<Player> squad) {
    List<Player> sorted = [...squad];

    sorted.sort((a, b) => b.overall.compareTo(a.overall));

    List<Player> starters = sorted.take(5).toList();

    return starters.fold(0, (sum, p) => sum + p.overall);
  }

  double formationAttackBoost(Formation f) {
    switch (f.name) {
      case "4-3-3":
        return 1.10;

      case "3-5-2":
        return 1.05;

      case "4-4-2":
      default:
        return 1.0;
    }
  }

  double formationDefenseBoost(Formation f) {
    switch (f.name) {
      case "3-5-2":
        return 1.10;

      case "4-4-2":
        return 1.05;

      case "4-3-3":
      default:
        return 0.95;
    }
  }

  Map<String, int> simulateMatch(double strengthA, double strengthB) {
    double diff = strengthA - strengthB;

    double winA = 1 / (1 + exp(-diff / 12));

    double draw = 0.22 * exp(-diff.abs() / 25);

    double winB = 1 - winA - draw;

    double total = winA + draw + winB;

    winA /= total;
    draw /= total;
    winB /= total;

    double roll = rng.nextDouble();

    if (roll < winA) {
      return {"a": 1 + rng.nextInt(3), "b": rng.nextInt(2)};
    } else if (roll < winA + draw) {
      int g = rng.nextInt(3);

      return {"a": g, "b": g};
    } else {
      return {"a": rng.nextInt(2), "b": 1 + rng.nextInt(3)};
    }
  }

  List<String> generateMatchEvents(
    TeamModel home,
    TeamModel away,
    int homeGoals,
    int awayGoals,
  ) {
    List<String> events = [];

    events.add("🏟️ ${home.name} vs ${away.name}");
    events.add("");

    List<Player> homeAttackers = home.squad
        .where((p) => p.position != "DEF")
        .toList();

    List<Player> awayAttackers = away.squad
        .where((p) => p.position != "DEF")
        .toList();

    for (int i = 0; i < homeGoals; i++) {
      int minute = 1 + rng.nextInt(90);

      Player scorer = homeAttackers[rng.nextInt(homeAttackers.length)];

      scorer.goals++;

      events.add("⚽ $minute' ${scorer.name} scores for ${home.name}!");
    }

    for (int i = 0; i < awayGoals; i++) {
      int minute = 1 + rng.nextInt(90);

      Player scorer = awayAttackers[rng.nextInt(awayAttackers.length)];

      scorer.goals++;

      events.add("⚽ $minute' ${scorer.name} scores for ${away.name}!");
    }

    events.add("");
    events.add("📊 FINAL SCORE");
    events.add("${home.name} $homeGoals - $awayGoals ${away.name}");

    return events;
  }
}
