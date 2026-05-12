import 'package:flutter/material.dart';

import '../models/player.dart';

class TeamScreen extends StatelessWidget {
  final List<Player> team;
  final Function(Player) onTrain;
  final Function(Player) onSell;

  const TeamScreen({
    super.key,
    required this.team,
    required this.onTrain,
    required this.onSell,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: team.length,
            itemBuilder: (context, index) {
              final player = team[index];

              int sellPrice;

              if (player.price >= 70) {
                sellPrice = (player.price * 0.6).toInt();
              } else if (player.price >= 40) {
                sellPrice = (player.price * 0.7).toInt();
              } else {
                sellPrice = (player.price * 0.8).toInt();
              }

              return Card(
                child: ListTile(
                  title: Text(player.name),

                  subtitle: Text(
                    "Age:${player.age} | Pos:${player.position} | Attack:${player.attack} | Defence:${player.defense} | OVR:${player.overall} | £${player.price}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fitness_center),
                        onPressed: () => onTrain(player),
                      ),

                      ElevatedButton(
                        onPressed: () => onSell(player),
                        child: Text("Sell £$sellPrice"),
                      ),
                    ],
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
