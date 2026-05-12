import '../models/formation.dart';

class GameFormations {
  static final List<Formation> formations = [
    Formation("4-4-2", [
      "GK",
      "DEF",
      "DEF",
      "DEF",
      "DEF",
      "MID",
      "MID",
      "MID",
      "MID",
      "FWD",
      "FWD",
    ]),

    Formation("4-3-3", [
      "GK",
      "DEF",
      "DEF",
      "DEF",
      "DEF",
      "MID",
      "MID",
      "MID",
      "FWD",
      "FWD",
      "FWD",
    ]),

    Formation("3-5-2", [
      "GK",
      "DEF",
      "DEF",
      "DEF",
      "MID",
      "MID",
      "MID",
      "MID",
      "MID",
      "FWD",
      "FWD",
    ]),
  ];
}
