import 'dart:math';

import '../models/player.dart';

class TransferService {
  static void buyPlayer({
    required List<Player> team,
    required List<Player> market,
    required Player player,
    required Function(String) addText,
    required Function(int) updateBudget,
    required int budget,
  }) {
    if (budget < player.price) {
      addText("❌ Not enough budget!");
      return;
    }

    if (team.contains(player)) return;

    team.add(player);
    market.remove(player);

    updateBudget(budget - player.price);

    addText("✅ Bought ${player.name} for £${player.price}!");
  }

  static void sellPlayer({
    required List<Player> team,
    required List<Player> market,
    required Player player,
    required Function(String) addText,
    required Function(int) updateBudget,
    required int budget,
  }) {
    if (team.length <= 1) {
      addText("❌ You need at least 1 player!");
      return;
    }

    double rate;

    if (player.price >= 70) {
      rate = 0.6;
    } else if (player.price >= 40) {
      rate = 0.7;
    } else {
      rate = 0.8;
    }

    int sellPrice = (player.price * rate).toInt();

    team.remove(player);

    market.add(player);

    updateBudget(budget + sellPrice);

    addText("💸 Sold ${player.name} for £$sellPrice");
  }

  static List<Player> generateMarket({
    required Random rng,
    required String Function() generatePlayerName,
    required String Function() generatePosition,
    int amount = 5,
  }) {
    return List.generate(amount, (_) {
      return Player(
        generatePlayerName(),
        4 + rng.nextInt(6),
        4 + rng.nextInt(6),
        position: generatePosition(),
      );
    });
  }
}
