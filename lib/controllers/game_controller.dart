import 'dart:math';
import '../models/screen_type.dart';
import '../models/player.dart';
import '../models/team_model.dart';
import '../models/formation.dart';

class GameController {
  final Random rng = Random();

  String log = "⚽ Welcome to Football Manager Lite!\n";

  ScreenType screen = ScreenType.home;

  int day = 1;

  int budget = 100;

  List<Player> team = [];

  List<Player> market = [];

  List<TeamModel> league = [];

  List<String> matchLog = [];

  TeamModel? selectedTeam;

  late Formation selectedFormation;
}
