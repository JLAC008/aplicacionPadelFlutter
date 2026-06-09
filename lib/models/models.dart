// ignore_for_file: constant_identifier_names

enum ChallengeStatus { pending, accepted, awaitingVerification, completed, rejected }
enum Availability { morning, afternoon, evening, weekend, flexible }

class Player {
  final String id;
  final String name;
  final String avatarUrl;
  final double padelBandScore;
  final int padelBandRank;
  final String level;
  final String liga;
  final List<Availability> availability;

  const Player({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.padelBandScore,
    required this.padelBandRank,
    required this.level,
    required this.liga,
    required this.availability,
  });
}

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

class Liga {
  final String id;
  final String name;
  final String level;
  final String levelIcon;
  final List<Pair> pairs;
  int currentChallengerIndex;

  Liga({
    required this.id,
    required this.name,
    required this.level,
    required this.levelIcon,
    required this.pairs,
    this.currentChallengerIndex = 0,
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
