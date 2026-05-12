import 'dart:math';

class Player {
  String name;
  int attack;
  int defense;
  int cooldown = 0;
  int goals = 0;
  int assists = 0;
  int age;
  String position;

  Player(
    this.name,
    this.attack,
    this.defense, {
    required this.position,
    int? age,
  }) : age = age ?? (17 + Random().nextInt(18));

  int get overall => attack + defense;

  int get price => overall * 5;
}
