import 'package:flutter/material.dart';

import '../models/player.dart';

class MarketScreen extends StatelessWidget {
  final List<Player> market;
  final int budget;
  final Function(Player) onBuy;

  const MarketScreen({
    super.key,
    required this.market,
    required this.budget,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "💰 Budget: £$budget",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: market.length,
            itemBuilder: (context, index) {
              final player = market[index];

              return Card(
                child: ListTile(
                  title: Text(player.name),

                  subtitle: Text(
                    "Age:${player.age} | Pos:${player.position} | Attack:${player.attack} | Defence:${player.defense} | OVR:${player.overall} | £${player.price}",
                  ),

                  trailing: ElevatedButton(
                    onPressed: () => onBuy(player),
                    child: const Text("BUY"),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
