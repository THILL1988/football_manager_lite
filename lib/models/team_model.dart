import 'player.dart';

class TeamModel {
  String name;
  int points;
  int goalsFor;
  int goalsAgainst;
  int strength; // MUST be int
  List<Player> squad; // 👈 NEW

  TeamModel(
    this.name, {
    this.points = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.strength = 50,
    List<Player>? squad,
  }) : squad = squad ?? [];
}
