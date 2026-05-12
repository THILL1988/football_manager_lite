import 'dart:math';

import '../models/player.dart';

class TrainingService {
  static void runTraining({
    required List<Player> team,
    required String type,
    required Function(String) addText,
  }) {
    for (var p in team) {
      if (type == "attack") {
        p.attack += 1;
      } else if (type == "defense") {
        p.defense += 1;
      } else if (type == "balanced") {
        p.attack += 1;
        p.defense += 1;
      }
    }

    if (type == "attack") {
      addText("🔥 Attack training complete!");
    } else if (type == "defense") {
      addText("🛡 Defense training complete!");
    } else {
      addText("⚖ Balanced training complete!");
    }
  }

  static void trainPlayer({
    required Player player,
    required String type,
    required Function(String) addText,
  }) {
    if (type == "attack") {
      player.attack += 1;
      addText("🔥 ${player.name} gained +1 Attack!");
    } else if (type == "defense") {
      player.defense += 1;
      addText("🛡 ${player.name} gained +1 Defense!");
    } else {
      player.attack += 1;
      player.defense += 1;
      addText("⚖ ${player.name} gained +1 Attack & Defense!");
    }

    player.cooldown = 2;
  }

  static void applyDevelopment({required Player player, required Random rng}) {
    if (player.age <= 21) {
      if (rng.nextDouble() < 0.6) player.attack += 1;
      if (rng.nextDouble() < 0.6) player.defense += 1;
    } else if (player.age <= 28) {
      if (rng.nextDouble() < 0.3) player.attack += 1;
      if (rng.nextDouble() < 0.3) player.defense += 1;
    } else if (player.age <= 33) {
      if (rng.nextDouble() < 0.25) {
        player.attack = (player.attack - 1).clamp(1, 99);
      }

      if (rng.nextDouble() < 0.25) {
        player.defense = (player.defense - 1).clamp(1, 99);
      }
    } else {
      if (rng.nextDouble() < 0.5) {
        player.attack = (player.attack - 1).clamp(1, 99);
      }

      if (rng.nextDouble() < 0.5) {
        player.defense = (player.defense - 1).clamp(1, 99);
      }
    }

    player.age += 1;
  }
}
