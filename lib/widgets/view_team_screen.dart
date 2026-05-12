import 'package:flutter/material.dart';

import '../models/team_model.dart';

class ViewTeamScreen extends StatelessWidget {
  final TeamModel? selectedTeam;
  final VoidCallback onBack;

  const ViewTeamScreen({
    super.key,
    required this.selectedTeam,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedTeam == null) {
      return const Center(child: Text("No team selected"));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "${selectedTeam!.name} Squad",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: selectedTeam!.squad.length,
            itemBuilder: (context, index) {
              final p = selectedTeam!.squad[index];

              return Card(
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                    "${p.position} | Attack: ${p.attack} | Defense: ${p.defense} | OVR: ${p.overall}",
                  ),
                ),
              );
            },
          ),
        ),

        ElevatedButton(onPressed: onBack, child: const Text("Back")),
      ],
    );
  }
}
