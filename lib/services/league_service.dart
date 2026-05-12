import '../models/team_model.dart';

class LeagueService {
  void sortLeagueTable(List<TeamModel> league) {
    league.sort((a, b) {
      int cmp = b.points.compareTo(a.points);

      if (cmp != 0) return cmp;

      int gdA = a.goalsFor - a.goalsAgainst;
      int gdB = b.goalsFor - b.goalsAgainst;

      cmp = gdB.compareTo(gdA);

      if (cmp != 0) return cmp;

      return b.goalsFor.compareTo(a.goalsFor);
    });
  }
}
