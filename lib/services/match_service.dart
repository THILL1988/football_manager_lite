import 'dart:math';

import '../models/player.dart';
import '../models/team_model.dart';
import '../models/formation.dart';
import 'match_engine.dart';
import 'league_service.dart';

class MatchService {
  static void playMatch({
    required int day,
    required int seasonLength,
    required List<Player> team,
    required List<TeamModel> league,
    required Formation selectedFormation,
    required MatchEngine engine,
    required LeagueService leagueService,
    required Random rng,
    required Function(String) addText,
    required Function(List<String>) updateMatchLog,
    required Function() onSeasonEnd,
    required Function() onDayAdvance,
  }) {
    // -----------------------------
    // SEASON FINISHED
    // -----------------------------
    if (day > seasonLength) {
      addText("🏁 SEASON COMPLETE!");
      onSeasonEnd();
      return;
    }

    List<String> matchLog = [];

    // -----------------------------
    // PICK TEAMS
    // -----------------------------
    final userTeam = league.firstWhere((t) => t.name == "You");

    final opponents = league.where((t) => t.name != "You").toList();

    final opponent = opponents[rng.nextInt(opponents.length)];

    // -----------------------------
    // CALCULATE STRENGTH
    // -----------------------------
    final baseUser = engine.calculateTeamStrength(team);

    final baseOpp = engine.calculateTeamStrength(opponent.squad);

    double userAtk = engine.formationAttackBoost(selectedFormation);

    double userDef = engine.formationDefenseBoost(selectedFormation);

    double oppAtk = 1.0;
    double oppDef = 1.0;

    double userStrength =
        (baseUser * 0.6 * userAtk) + (baseUser * 0.4 * userDef);

    double oppStrength = (baseOpp * 0.6 * oppAtk) + (baseOpp * 0.4 * oppDef);

    // -----------------------------
    // PLAY MATCH
    // -----------------------------
    var result = engine.simulateMatch(userStrength, oppStrength);

    int userGoals = result["a"]!;
    int opponentGoals = result["b"]!;

    // -----------------------------
    // COMMENTARY
    // -----------------------------
    matchLog = engine.generateMatchEvents(
      userTeam,
      opponent,
      userGoals,
      opponentGoals,
    );

    addText(matchLog.join("\n"));

    // -----------------------------
    // UPDATE STATS
    // -----------------------------
    userTeam.goalsFor += userGoals;
    userTeam.goalsAgainst += opponentGoals;

    opponent.goalsFor += opponentGoals;
    opponent.goalsAgainst += userGoals;

    // -----------------------------
    // POINTS
    // -----------------------------
    if (userGoals > opponentGoals) {
      userTeam.points += 3;
      addText("🏆 You win!");
    } else if (userGoals == opponentGoals) {
      userTeam.points += 1;
      opponent.points += 1;
      addText("🤝 Draw!");
    } else {
      opponent.points += 3;
      addText("😢 You lost!");
    }

    // -----------------------------
    // SIMULATE OTHER MATCHES
    // -----------------------------
    List<TeamModel> rivals = league.where((t) => t.name != "You").toList();

    rivals.shuffle();

    for (int i = 0; i < rivals.length - 1; i += 2) {
      TeamModel teamA = rivals[i];
      TeamModel teamB = rivals[i + 1];

      int strengthA = engine.calculateTeamStrength(teamA.squad);

      int strengthB = engine.calculateTeamStrength(teamB.squad);

      var otherResult = engine.simulateMatch(
        strengthA.toDouble(),
        strengthB.toDouble(),
      );

      int goalsA = otherResult["a"]!;
      int goalsB = otherResult["b"]!;

      teamA.goalsFor += goalsA;
      teamA.goalsAgainst += goalsB;

      teamB.goalsFor += goalsB;
      teamB.goalsAgainst += goalsA;

      if (goalsA > goalsB) {
        teamA.points += 3;
      } else if (goalsB > goalsA) {
        teamB.points += 3;
      } else {
        teamA.points += 1;
        teamB.points += 1;
      }

      addText("📡 ${teamA.name} $goalsA - $goalsB ${teamB.name}");
    }

    // -----------------------------
    // SORT TABLE
    // -----------------------------
    leagueService.sortLeagueTable(league);

    addText("📅 Day $day completed");

    // -----------------------------
    // PLAYER RECOVERY
    // -----------------------------
    for (var p in team) {
      if (p.cooldown > 0) {
        p.cooldown--;
      }
    }

    // -----------------------------
    // SAVE MATCH LOG
    // -----------------------------
    updateMatchLog(matchLog);

    // -----------------------------
    // ADVANCE DAY
    // -----------------------------
    onDayAdvance();

    // -----------------------------
    // END OF SEASON CHECK
    // -----------------------------
    if (day + 1 > seasonLength) {
      addText("🏁 SEASON COMPLETE!");
      onSeasonEnd();
    }
  }
}
