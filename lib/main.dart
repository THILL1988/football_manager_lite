import 'package:flutter/material.dart';
import 'dart:math';
import 'models/player.dart';
import 'services/match_engine.dart';
import 'services/league_service.dart';
import 'services/transfer_service.dart';
import 'services/training_service.dart';
import 'widgets/team_screen.dart';
import 'widgets/market_screen.dart';
import 'widgets/league_screen.dart';
import 'widgets/view_team_screen.dart';
import 'services/season_service.dart';
import 'services/match_service.dart';
import 'services/game_initializer.dart';
import 'constants/game_constants.dart';
import 'controllers/game_controller.dart';
import 'constants/formations.dart';
import 'models/screen_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random rng = Random();

  final GameController game = GameController();

  final MatchEngine engine = MatchEngine();
  final LeagueService leagueService = LeagueService();

  int seasonLength = GameConstants.seasonLength;

  void addText(String text) {
    game.log += "\n$text";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    game.selectedFormation = GameFormations.formations[0];

    final gameData = GameInitializer.initializeGame(rng: rng);

    game.team.clear();
    game.team.addAll(gameData.userTeam);

    game.league = gameData.league;

    game.market = gameData.market;
  }

  void showPlayerTraining(Player player) {
    if (player.cooldown > 0) {
      addText(
        "⏳ ${player.name} is tired! Cooldown: ${player.cooldown} days left.",
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Train ${player.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TrainingService.trainPlayer(
                      player: player,
                      type: "attack",
                      addText: addText,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Attack Training (+1 Attack)"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TrainingService.trainPlayer(
                      player: player,
                      type: "defense",
                      addText: addText,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Defense Training (+1 Defense)"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TrainingService.trainPlayer(
                      player: player,
                      type: "balanced",
                      addText: addText,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Balanced (+1 Attack & Defense)"),
              ),
            ],
          ),
        );
      },
    );
  }

  void resetSeason() {
    setState(() {
      game.day = 1;

      game.market = SeasonService.resetSeason(
        league: game.league,
        rng: rng,
        addText: addText,
        generatePlayerName: () => GameInitializer.generatePlayerName(rng),
        generatePosition: () => GameInitializer.generatePosition(rng),
      );

      game.matchLog.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Football Manager Lite")),

      body: Column(
        children: [
          // 🔥 MAIN SCREEN AREA
          Expanded(
            child: Builder(
              builder: (context) {
                if (game.screen == ScreenType.market) {
                  return MarketScreen(
                    market: game.market,
                    budget: game.budget,
                    onBuy: (player) {
                      setState(() {
                        TransferService.buyPlayer(
                          team: game.team,
                          market: game.market,
                          player: player,
                          budget: game.budget,
                          updateBudget: (value) => game.budget = value,
                          addText: addText,
                        );
                      });
                    },
                  );
                }

                if (game.screen == ScreenType.team) {
                  return TeamScreen(
                    team: game.team,
                    onTrain: showPlayerTraining,
                    onSell: (player) {
                      setState(() {
                        TransferService.sellPlayer(
                          team: game.team,
                          market: game.market,
                          player: player,
                          budget: game.budget,
                          updateBudget: (value) => game.budget = value,
                          addText: addText,
                        );
                      });
                    },
                  );
                }

                if (game.screen == ScreenType.league) {
                  leagueService.sortLeagueTable(game.league);

                  return LeagueScreen(
                    league: game.league,
                    onSelectTeam: (team) {
                      setState(() {
                        game.selectedTeam = team;
                        game.screen = ScreenType.viewTeam;
                      });
                    },
                  );
                }

                if (game.screen == ScreenType.viewTeam) {
                  return ViewTeamScreen(
                    selectedTeam: game.selectedTeam,
                    onBack: () {
                      setState(() {
                        game.screen = ScreenType.league;
                      });
                    },
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "📅 Day: $game.day / $seasonLength",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          game.log,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 🔥 BUTTON PANEL (FIXED)
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                // ⭐ TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => game.screen = ScreenType.team),
                      child: const Text("Team"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          int index = GameFormations.formations.indexOf(
                            game.selectedFormation,
                          );

                          game.selectedFormation =
                              GameFormations.formations[(index + 1) %
                                  GameFormations.formations.length];
                        });

                        addText("📐 Formation: ${game.selectedFormation.name}");
                      },
                      child: Text(game.selectedFormation.name),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => game.screen = ScreenType.home),
                      child: const Text("🏠 Home"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          game.log = ""; // ✅ Clear yesterday’s log
                          game.screen = ScreenType.home;
                        });

                        MatchService.playMatch(
                          day: game.day,
                          seasonLength: seasonLength,
                          team: game.team,
                          league: game.league,
                          selectedFormation: game.selectedFormation,
                          engine: engine,
                          leagueService: leagueService,
                          rng: rng,
                          addText: addText,
                          updateMatchLog: (value) {
                            game.matchLog = value;
                          },
                          onSeasonEnd: () {
                            SeasonService.showSeasonTable(
                              league: game.league,
                              addText: addText,
                              resetSeason: resetSeason,
                              budget: game.budget,
                              updateBudget: (value) {
                                setState(() {
                                  game.budget = value;
                                });
                              },
                            );
                          },
                          onDayAdvance: () {
                            setState(() {
                              game.day++;
                            });
                          },
                        );
                      },
                      child: const Text("Next Day"),
                    ),
                  ],
                ),

                // ⭐ SECOND ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => game.screen = ScreenType.league),
                      child: const Text("League"),
                    ),

                    ElevatedButton(
                      onPressed: () =>
                          setState(() => game.screen = ScreenType.market),
                      child: const Text("Market"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
