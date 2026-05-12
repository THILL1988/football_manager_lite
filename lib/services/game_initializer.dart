import 'dart:math';

import '../models/player.dart';
import '../models/team_model.dart';
import 'transfer_service.dart';

class GameInitializationData {
  final List<Player> userTeam;
  final List<TeamModel> league;
  final List<Player> market;

  GameInitializationData({
    required this.userTeam,
    required this.league,
    required this.market,
  });
}

class GameInitializer {
  static final List<String> firstNames = [
    "Liam",
    "Noah",
    "Oliver",
    "Ethan",
    "Mason",
    "Kai",
    "Leo",
    "Hugo",
    "Mateo",
    "Tariq",
    "Jonas",
    "Felix",
    "Marco",
    "Sven",
    "Luca",
  ];

  static final List<String> lastNames = [
    "Martinez",
    "Santos",
    "Okafor",
    "Bennett",
    "Khan",
    "Nakamura",
    "Müller",
    "Svensson",
    "Hernandez",
    "Petrov",
    "Kovacs",
    "Rossi",
    "Novak",
    "Diaz",
  ];

  static String generatePlayerName(Random rng) {
    final first = firstNames[rng.nextInt(firstNames.length)];
    final last = lastNames[rng.nextInt(lastNames.length)];

    return "${first[0]}. $last";
  }

  static String generatePosition(Random rng) {
    double roll = rng.nextDouble();

    if (roll < 0.12) return "GK";
    if (roll < 0.40) return "DEF";
    if (roll < 0.75) return "MID";

    return "FWD";
  }

  static GameInitializationData initializeGame({required Random rng}) {
    List<Player> userTeam = List.generate(7, (i) {
      int atk = 4 + rng.nextInt(6);
      int def = 4 + rng.nextInt(6);

      return Player(
        generatePlayerName(rng),
        atk,
        def,
        position: generatePosition(rng),
      );
    });

    List<TeamModel> league = [];

    league.add(TeamModel("You", strength: 60, squad: userTeam));

    for (int i = 1; i < 10; i++) {
      int baseStrength;

      if (i <= 2) {
        baseStrength = 70 + rng.nextInt(10);
      } else if (i <= 5) {
        baseStrength = 55 + rng.nextInt(10);
      } else {
        baseStrength = 40 + rng.nextInt(10);
      }

      int squadSize = 7 + rng.nextInt(3);

      List<Player> squad = List.generate(squadSize, (index) {
        return Player(
          generatePlayerName(rng),
          (baseStrength ~/ 10) + rng.nextInt(5),
          (baseStrength ~/ 10) + rng.nextInt(5),
          position: generatePosition(rng),
        );
      });

      league.add(TeamModel("Club $i", strength: baseStrength, squad: squad));
    }

    List<Player> market = TransferService.generateMarket(
      rng: rng,
      generatePlayerName: () => generatePlayerName(rng),
      generatePosition: () => generatePosition(rng),
    );

    return GameInitializationData(
      userTeam: userTeam,
      league: league,
      market: market,
    );
  }
}
