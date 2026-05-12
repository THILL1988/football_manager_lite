import 'package:flutter/material.dart';

import '../models/team_model.dart';

class LeagueScreen extends StatelessWidget {
  final List<TeamModel> league;
  final Function(TeamModel) onSelectTeam;

  const LeagueScreen({
    super.key,
    required this.league,
    required this.onSelectTeam,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: league.length,
      itemBuilder: (context, index) {
        final t = league[index];

        int gd = t.goalsFor - t.goalsAgainst;

        return Card(
          child: ListTile(
            onTap: () => onSelectTeam(t),

            leading: Text(
              "${index + 1}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            title: Text(
              t.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            subtitle: Text(
              "Pts: ${t.points}   GF: ${t.goalsFor}   GA: ${t.goalsAgainst}   GD: $gd",
            ),
          ),
        );
      },
    );
  }
}
