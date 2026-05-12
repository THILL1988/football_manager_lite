import 'dart:math';

import '../models/player.dart';
import '../models/team_model.dart';
import 'league_service.dart';
import 'training_service.dart';

class SeasonService {
  static void showSeasonTable({
    required List<TeamModel> league,
    required Function(String) addText,
    required Function() resetSeason,
    required Function(int) updateBudget,
    required int budget,
  }) {
    LeagueService().sortLeagueTable(league);

    String table = "🏁 FINAL LEAGUE TABLE\n\n";

    for (var t in league) {
      table +=
          "${t.name} | Pts:${t.points} | GF:${t.goalsFor} | GA:${t.goalsAgainst}\n";
    }

    int firstPrize = 100;
    int secondPrize = 50;
    int thirdPrize = 20;

    TeamModel? first = league.isNotEmpty ? league[0] : null;
    TeamModel? second = league.length > 1 ? league[1] : null;
    TeamModel? third = league.length > 2 ? league[2] : null;

    int newBudget = budget;

    if (first?.name == "You") {
      newBudget += firstPrize;
      addText("🏆 You finished 1st! Awarded £$firstPrize");
    }

    if (second?.name == "You") {
      newBudget += secondPrize;
      addText("🥈 You finished 2nd! Awarded £$secondPrize");
    }

    if (third?.name == "You") {
      newBudget += thirdPrize;
      addText("🥉 You finished 3rd! Awarded £$thirdPrize");
    }

    updateBudget(newBudget);

    addText(table);

    resetSeason();
  }

  static List<Player> resetSeason({
    required List<TeamModel> league,
    required Random rng,
    required Function(String) addText,
    required String Function() generatePlayerName,
    required String Function() generatePosition,
  }) {
    int marketSize = 3 + rng.nextInt(5);

    double superstarChance = 0.1;
    double legendaryChance = 0.02;

    List<String> seasonMessages = [];

    for (var t in league) {
      t.points = 0;
      t.goalsFor = 0;
      t.goalsAgainst = 0;

      for (var p in t.squad) {
        TrainingService.applyDevelopment(player: p, rng: rng);
      }
    }

    List<Player> market = List.generate(marketSize, (_) {
      int skill1 = 4 + rng.nextInt(6);
      int skill2 = 4 + rng.nextInt(6);

      double roll = rng.nextDouble();

      if (roll < legendaryChance) {
        skill1 += 5 + rng.nextInt(6);
        skill2 += 5 + rng.nextInt(6);

        seasonMessages.add("🌟 A legendary player has appeared!");
      } else if (roll < legendaryChance + superstarChance) {
        skill1 += 3 + rng.nextInt(3);
        skill2 += 3 + rng.nextInt(3);

        seasonMessages.add("✨ A superstar has joined the market!");
      }

      return Player(
        generatePlayerName(),
        skill1,
        skill2,
        position: generatePosition(),
      );
    });

    Future.microtask(() {
      for (var msg in seasonMessages) {
        addText(msg);
      }

      addText("🔄 New season has begun! $marketSize players are available.");
    });

    return market;
  }
}
