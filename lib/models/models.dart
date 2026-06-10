// ignore_for_file: constant_identifier_names

enum ChallengeStatus { pending, accepted, awaitingVerification, completed, rejected }
enum Availability { morning, afternoon, evening, weekend, flexible }
enum TournamentPhase { draft, regularSeason, repechage, quarterFinal, semiFinal, grandFinal, finished }
enum TeamType { duo, trio }
enum UserRole { user, admin }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String avatarUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.user,
    required this.avatarUrl,
  });

  bool get isAdmin => role == UserRole.admin;
}

class Player {
  final String id;
  final String name;
  final String avatarUrl;
  double padelBandScore;
  int padelBandRank;
  final String level;
  final String liga;
  final List<Availability> availability;
  double strikeRate;

  Player({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.padelBandScore,
    required this.padelBandRank,
    required this.level,
    required this.liga,
    required this.availability,
    this.strikeRate = 0,
  });
}

class Team {
  final String id;
  final List<Player> players;     // 2 for duo, 3 for trio
  final TeamType type;
  String? teamName;
  int wins;
  int losses;
  int position;
  int points;                      // points for ranking
  double mediaTecnica;            // average strike rate across players
  bool hasCompletedChallenge;
  int jornadasGanadas;            // for priority system
  int block;                      // 0 = unranked (draft), 1 = Block A (7-12), 2 = Block B (1-6)

  Team({
    required this.id,
    required this.players,
    required this.type,
    this.teamName,
    this.wins = 0,
    this.losses = 0,
    this.position = 0,
    this.points = 0,
    this.mediaTecnica = 0,
    this.hasCompletedChallenge = false,
    this.jornadasGanadas = 0,
    this.block = 0,
  });

  String get displayName => teamName ?? players.map((p) => p.name).join(' & ');
  int get matchesPlayed => wins + losses;
  double get winRate => matchesPlayed > 0 ? wins / matchesPlayed : 0;
}

class Liga {
  final String id;
  final String name;
  final String level;
  final String levelIcon;
  final List<Team> teams;
  final List<Pair> pairs;
  int currentJornada;
  int currentChallengerIndex;
  TournamentPhase phase;
  List<Match> matches;
  Map<int, List<String>> prioridadHistorial;

  Liga({
    required this.id,
    required this.name,
    required this.level,
    required this.levelIcon,
    List<Team>? teams,
    List<Pair>? pairs,
    this.currentJornada = 0,
    this.currentChallengerIndex = 0,
    this.phase = TournamentPhase.draft,
    List<Match>? matches,
    Map<int, List<String>>? prioridadHistorial,
  })  : teams = teams ?? [],
        pairs = pairs ?? [],
        matches = matches ?? [],
        prioridadHistorial = prioridadHistorial ?? {};
}

class Match {
  final String id;
  final Team team1;
  final Team team2;
  final String ligaId;
  final TournamentPhase phase;
  final int jornada;
  int? set1Team1;
  int? set1Team2;
  int? set2Team1;
  int? set2Team2;
  int? set3Team1;          // supertiebreak or full 3rd set
  int? set3Team2;
  String? winnerId;
  bool goldenPoint;        // punto de oro activo
  int durationMinutes;
  DateTime? scheduledDate;
  String? timeSlot;
  String status;           // scheduled, live, finished, walkover, forfeit
  String? forfeitReason;
  int? team1PenaltyGames;  // for delay penalties (-3 games, -6 games)
  String? mediaUrl;        // video coverage link
  String? photoUrl;        // photo coverage

  Match({
    required this.id,
    required this.team1,
    required this.team2,
    required this.ligaId,
    required this.phase,
    this.jornada = 0,
    this.set1Team1,
    this.set1Team2,
    this.set2Team1,
    this.set2Team2,
    this.set3Team1,
    this.set3Team2,
    this.winnerId,
    this.goldenPoint = false,
    this.durationMinutes = 0,
    this.scheduledDate,
    this.timeSlot,
    this.status = 'scheduled',
    this.forfeitReason,
    this.team1PenaltyGames,
    this.mediaUrl,
    this.photoUrl,
  });

  bool get isFinished => status == 'finished';
  bool get isWalkover => status == 'walkover';
  bool get isForfeit => status == 'forfeit';

  int? get team1Sets {
    if (!isFinished) return null;
    int sets = 0;
    if (set1Team1 != null && set1Team2 != null) {
      if (set1Team1! > set1Team2!) sets++;
    }
    if (set2Team1 != null && set2Team2 != null) {
      if (set2Team1! > set2Team2!) sets++;
    }
    if (set3Team1 != null && set3Team2 != null) {
      if (set3Team1! > set3Team2!) sets++;
    }
    return sets;
  }

  int? get team2Sets {
    if (!isFinished) return null;
    int sets = 0;
    if (set1Team1 != null && set1Team2 != null) {
      if (set1Team2! > set1Team1!) sets++;
    }
    if (set2Team1 != null && set2Team2 != null) {
      if (set2Team2! > set2Team1!) sets++;
    }
    if (set3Team1 != null && set3Team2 != null) {
      if (set3Team2! > set3Team1!) sets++;
    }
    return sets;
  }
}

class Season {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Liga> ligas;
  final List<Match> allMatches;
  final Map<int, DateTime> jornadaDeadlines;  // jornada -> deadline (Monday)

  Season({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.ligas,
    required this.allMatches,
    required this.jornadaDeadlines,
  });
}

class DraftResult {
  final Player player;
  final double strikeRate;
  final int position;

  DraftResult({
    required this.player,
    required this.strikeRate,
    required this.position,
  });
}

class CalendarEvent {
  final DateTime date;
  final String title;
  final String description;
  final String type;     // challengeDay, playDay, deadline, event, final

  CalendarEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
  });
}

// ── Legacy Models ──
class Pair {
  final String id;
  final Player player1;
  final Player player2;
  final String? teamName;
  int wins;
  int losses;
  int position;
  bool hasCompletedChallenge;

  Pair({
    required this.id,
    required this.player1,
    required this.player2,
    this.teamName,
    required this.wins,
    required this.losses,
    required this.position,
    this.hasCompletedChallenge = false,
  });
}

class Challenge {
  final String id;
  final Pair challenger;
  final Pair challenged;
  final String ligaId;
  final String ligaName;
  ChallengeStatus status;
  String? proposedDate;
  String? scoreChallenger;
  String? scoreChallenged;
  bool challengerWon;

  Challenge({
    required this.id,
    required this.challenger,
    required this.challenged,
    required this.ligaId,
    required this.ligaName,
    required this.status,
    this.proposedDate,
    this.scoreChallenger,
    this.scoreChallenged,
    this.challengerWon = false,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final String avatarUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.avatarUrl,
  });
}

class Pista {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final List<String> amenities;
  final bool indoor;
  final double pricePerHour;

  const Pista({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.amenities,
    required this.indoor,
    required this.pricePerHour,
  });
}

class Reserva {
  final String id;
  final String pistaId;
  final String pistaName;
  final DateTime date;
  final String timeSlot;
  final String reservedBy;
  final String status;

  const Reserva({
    required this.id,
    required this.pistaId,
    required this.pistaName,
    required this.date,
    required this.timeSlot,
    required this.reservedBy,
    this.status = 'confirmed',
  });
}

class PadelBandRanking {
  final Player player;
  final int rank;
  final double score;
  final int matchesPlayed;
  final int wins;
  final int losses;

  const PadelBandRanking({
    required this.player,
    required this.rank,
    required this.score,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
  });
}
