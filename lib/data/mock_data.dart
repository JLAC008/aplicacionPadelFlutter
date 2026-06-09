import '../models/models.dart';

// ───────────────────────── PLAYERS ─────────────────────────
final Player pJuan = Player(
  id: 'p1',
  name: 'Juan',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 8.5,
  padelBandRank: 1,
  avatarUrl:
      'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pPedro = Player(
  id: 'p2',
  name: 'Pedro',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 8.2,
  padelBandRank: 2,
  avatarUrl:
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.afternoon, Availability.weekend],
);
final Player pJaime = Player(
  id: 'p3',
  name: 'Jaime',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 8.0,
  padelBandRank: 3,
  avatarUrl:
      'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.evening],
);
final Player pMarcos = Player(
  id: 'p4',
  name: 'Marcos',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 7.8,
  padelBandRank: 4,
  avatarUrl:
      'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.weekend, Availability.flexible],
);
final Player pPam = Player(
  id: 'p5',
  name: 'Pam',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 7.6,
  padelBandRank: 5,
  avatarUrl:
      'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.afternoon],
);
final Player pCarlos = Player(
  id: 'p6',
  name: 'Carlos',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 7.4,
  padelBandRank: 6,
  avatarUrl:
      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pMaria = Player(
  id: 'p7',
  name: 'Maria',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 7.2,
  padelBandRank: 7,
  avatarUrl:
      'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.afternoon, Availability.weekend],
);
final Player pCarlos2 = Player(
  id: 'p8',
  name: 'Carlos B',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 7.0,
  padelBandRank: 8,
  avatarUrl:
      'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.flexible],
);
final Player pMaria2 = Player(
  id: 'p9',
  name: 'Maria L',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 6.8,
  padelBandRank: 9,
  avatarUrl:
      'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pBere = Player(
  id: 'p10',
  name: 'Bere',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 6.5,
  padelBandRank: 10,
  avatarUrl:
      'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.afternoon],
);
final Player pMati = Player(
  id: 'p11',
  name: 'Mati',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 6.3,
  padelBandRank: 11,
  avatarUrl:
      'https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.weekend, Availability.flexible],
);
final Player pBeamos = Player(
  id: 'p12',
  name: 'Beamos',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 6.0,
  padelBandRank: 12,
  avatarUrl:
      'https://images.pexels.com/photos/1462980/pexels-photo-1462980.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pLigera = Player(
  id: 'p13',
  name: 'Ligera',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 5.8,
  padelBandRank: 13,
  avatarUrl:
      'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.weekend],
);
final Player pDaopo = Player(
  id: 'p14',
  name: 'Daopo',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 5.5,
  padelBandRank: 14,
  avatarUrl:
      'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.afternoon, Availability.weekend],
);
final Player pLommelan = Player(
  id: 'p15',
  name: 'Lommelan',
  level: 'Avanzado',
  liga: 'Liga Peso Pesado',
  padelBandScore: 5.3,
  padelBandRank: 15,
  avatarUrl:
      'https://images.pexels.com/photos/1300402/pexels-photo-1300402.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.flexible],
);

// Liga Medio players
final Player pAna = Player(
  id: 'p16',
  name: 'Ana',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 5.0,
  padelBandRank: 16,
  avatarUrl:
      'https://images.pexels.com/photos/1587009/pexels-photo-1587009.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.afternoon],
);
final Player pLuis = Player(
  id: 'p17',
  name: 'Luis',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 4.8,
  padelBandRank: 17,
  avatarUrl:
      'https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pSofia = Player(
  id: 'p18',
  name: 'Sofia',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 4.5,
  padelBandRank: 18,
  avatarUrl:
      'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.afternoon, Availability.weekend],
);
final Player pRafael = Player(
  id: 'p19',
  name: 'Rafael',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 4.2,
  padelBandRank: 19,
  avatarUrl:
      'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.flexible],
);
final Player pElena = Player(
  id: 'p20',
  name: 'Elena',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 4.0,
  padelBandRank: 20,
  avatarUrl:
      'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.evening, Availability.weekend],
);
final Player pDiego = Player(
  id: 'p21',
  name: 'Diego',
  level: 'Intermedio',
  liga: 'Liga Peso Medio',
  padelBandScore: 3.8,
  padelBandRank: 21,
  avatarUrl:
      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=150',
  availability: [Availability.morning, Availability.afternoon],
);

// ───────────────────────── PAIRS ─────────────────────────
final Pair pairJuanPedro = Pair(
  id: 'pair1',
  player1: pJuan,
  player2: pPedro,
  wins: 3,
  losses: 1,
  position: 1,
  hasCompletedChallenge: true,
);
final Pair pairJaimePedro2 = Pair(
  id: 'pair2',
  player1: pJaime,
  player2: pMarcos,
  wins: 3,
  losses: 1,
  position: 2,
  hasCompletedChallenge: true,
);
final Pair pairPamMarcos = Pair(
  id: 'pair3',
  player1: pPam,
  player2: pMarcos,
  wins: 2,
  losses: 2,
  position: 3,
  teamName: 'Las Reinas',
);
final Pair pairCarlosMaria = Pair(
  id: 'pair4',
  player1: pCarlos,
  player2: pMaria,
  wins: 2,
  losses: 2,
  position: 4,
  teamName: 'Las Viboras',
);
final Pair pairCarlosMaria2 = Pair(
  id: 'pair5',
  player1: pCarlos2,
  player2: pMaria2,
  wins: 2,
  losses: 2,
  position: 5,
);
final Pair pairBereMati = Pair(
  id: 'pair6',
  player1: pBere,
  player2: pMati,
  wins: 1,
  losses: 3,
  position: 6,
);
final Pair pairBeamosLigeras = Pair(
  id: 'pair7',
  player1: pBeamos,
  player2: pLigera,
  wins: 1,
  losses: 3,
  position: 7,
  teamName: 'Las Ligeras',
);
final Pair pairDaopoLommelan = Pair(
  id: 'pair8',
  player1: pDaopo,
  player2: pLommelan,
  wins: 0,
  losses: 4,
  position: 8,
);

final Pair pairAnaDiego = Pair(
  id: 'pair9',
  player1: pAna,
  player2: pDiego,
  wins: 4,
  losses: 0,
  position: 1,
);
final Pair pairLuisSofia = Pair(
  id: 'pair10',
  player1: pLuis,
  player2: pSofia,
  wins: 3,
  losses: 1,
  position: 2,
);
final Pair pairRafaelElena = Pair(
  id: 'pair11',
  player1: pRafael,
  player2: pElena,
  wins: 2,
  losses: 2,
  position: 3,
);

// ───────────────────────── LIGAS ─────────────────────────
final Liga ligaPesoPesado = Liga(
  id: 'liga1',
  name: 'Liga Peso Pesado',
  level: 'Avanzado',
  levelIcon: '🥊',
  pairs: [
    pairJuanPedro,
    pairJaimePedro2,
    pairPamMarcos,
    pairCarlosMaria,
    pairCarlosMaria2,
    pairBereMati,
    pairBeamosLigeras,
    pairDaopoLommelan
  ],
  currentChallengerIndex: 2,
);
final Liga ligaPesoMedio = Liga(
  id: 'liga2',
  name: 'Liga Peso Medio',
  level: 'Intermedio',
  levelIcon: '🎾',
  pairs: [pairAnaDiego, pairLuisSofia, pairRafaelElena],
  currentChallengerIndex: 0,
);
final Liga ligaPesoLigero = Liga(
  id: 'liga3',
  name: 'Liga Peso Ligero',
  level: 'Principiante',
  levelIcon: '⭐',
  pairs: [],
  currentChallengerIndex: 0,
);

final List<Liga> allLigas = [ligaPesoPesado, ligaPesoMedio, ligaPesoLigero];

// ───────────────────────── CHALLENGES ─────────────────────────
final List<Challenge> mockChallenges = [
  Challenge(
    id: 'ch1',
    challenger: pairJuanPedro,
    challenged: pairPamMarcos,
    ligaId: 'liga1',
    ligaName: 'Liga Peso Pesado',
    status: ChallengeStatus.awaitingVerification,
    proposedDate: 'Jue 5 Jun, 20:00',
    scoreChallenger: '6',
    scoreChallenged: '3',
    challengerWon: true,
  ),
  Challenge(
    id: 'ch2',
    challenger: pairBereMati,
    challenged: pairCarlosMaria,
    ligaId: 'liga1',
    ligaName: 'Liga Peso Pesado',
    status: ChallengeStatus.accepted,
    proposedDate: 'Sab 7 Jun, 11:00',
  ),
  Challenge(
    id: 'ch3',
    challenger: pairJaimePedro2,
    challenged: pairCarlosMaria2,
    ligaId: 'liga1',
    ligaName: 'Liga Peso Pesado',
    status: ChallengeStatus.completed,
    proposedDate: 'Mar 3 Jun, 19:00',
    scoreChallenger: '6',
    scoreChallenged: '4',
    challengerWon: true,
  ),
  Challenge(
    id: 'ch4',
    challenger: pairBeamosLigeras,
    challenged: pairDaopoLommelan,
    ligaId: 'liga1',
    ligaName: 'Liga Peso Pesado',
    status: ChallengeStatus.pending,
    proposedDate: 'Dom 8 Jun, 10:00',
  ),
];

// ───────────────────────── PADEL BAND RANKING ─────────────────────────
final List<PadelBandRanking> padelBandRanking = [
  PadelBandRanking(
      player: pJuan,
      rank: 1,
      score: 8.5,
      matchesPlayed: 12,
      wins: 9,
      losses: 3),
  PadelBandRanking(
      player: pPedro,
      rank: 2,
      score: 8.2,
      matchesPlayed: 11,
      wins: 8,
      losses: 3),
  PadelBandRanking(
      player: pJaime,
      rank: 3,
      score: 8.0,
      matchesPlayed: 10,
      wins: 7,
      losses: 3),
  PadelBandRanking(
      player: pMarcos,
      rank: 4,
      score: 7.8,
      matchesPlayed: 12,
      wins: 7,
      losses: 5),
  PadelBandRanking(
      player: pPam, rank: 5, score: 7.6, matchesPlayed: 10, wins: 6, losses: 4),
  PadelBandRanking(
      player: pCarlos,
      rank: 6,
      score: 7.4,
      matchesPlayed: 11,
      wins: 6,
      losses: 5),
  PadelBandRanking(
      player: pMaria,
      rank: 7,
      score: 7.2,
      matchesPlayed: 9,
      wins: 5,
      losses: 4),
  PadelBandRanking(
      player: pCarlos2,
      rank: 8,
      score: 7.0,
      matchesPlayed: 10,
      wins: 5,
      losses: 5),
  PadelBandRanking(
      player: pMaria2,
      rank: 9,
      score: 6.8,
      matchesPlayed: 8,
      wins: 4,
      losses: 4),
  PadelBandRanking(
      player: pBere,
      rank: 10,
      score: 6.5,
      matchesPlayed: 9,
      wins: 4,
      losses: 5),
  PadelBandRanking(
      player: pMati,
      rank: 11,
      score: 6.3,
      matchesPlayed: 8,
      wins: 3,
      losses: 5),
  PadelBandRanking(
      player: pBeamos,
      rank: 12,
      score: 6.0,
      matchesPlayed: 7,
      wins: 3,
      losses: 4),
  PadelBandRanking(
      player: pLigera,
      rank: 13,
      score: 5.8,
      matchesPlayed: 6,
      wins: 2,
      losses: 4),
  PadelBandRanking(
      player: pDaopo,
      rank: 14,
      score: 5.5,
      matchesPlayed: 7,
      wins: 2,
      losses: 5),
  PadelBandRanking(
      player: pLommelan,
      rank: 15,
      score: 5.3,
      matchesPlayed: 6,
      wins: 1,
      losses: 5),
];

// ───────────────────────── PISTAS ─────────────────────────
final List<Pista> mockPistas = [
  Pista(
    id: 'pista1',
    name: 'Pista Central',
    imageUrl: 'assets/images/generated/court-night.png',
    location: 'Club Principal',
    amenities: ['Vestuarios', 'Iluminación LED', 'Parking', 'Bar'],
    indoor: false,
    pricePerHour: 25.0,
  ),
  Pista(
    id: 'pista2',
    name: 'Pista de Cristal',
    imageUrl: 'assets/images/generated/court-night.png',
    location: 'Club Principal',
    amenities: ['Cristal trasero', 'Vestuarios', 'Parking'],
    indoor: false,
    pricePerHour: 30.0,
  ),
  Pista(
    id: 'pista3',
    name: 'Pista Indoor 1',
    imageUrl: 'assets/images/generated/court-night.png',
    location: 'Club Indoor',
    amenities: ['Climatizada', 'Vestuarios', 'Parking', 'Sauna'],
    indoor: true,
    pricePerHour: 35.0,
  ),
  Pista(
    id: 'pista4',
    name: 'Pista Indoor 2',
    imageUrl: 'assets/images/generated/court-night.png',
    location: 'Club Indoor',
    amenities: ['Climatizada', 'Vestuarios', 'Parking', 'Zona de relax'],
    indoor: true,
    pricePerHour: 32.0,
  ),
  Pista(
    id: 'pista5',
    name: 'Pista Anexo',
    imageUrl: 'assets/images/generated/court-night.png',
    location: 'Anexo Norte',
    amenities: ['Vestuarios', 'Iluminación básica'],
    indoor: false,
    pricePerHour: 18.0,
  ),
];

final List<Reserva> mockReservas = [
  Reserva(
    id: 'res1',
    pistaId: 'pista2',
    pistaName: 'Pista de Cristal',
    date: DateTime.now().add(const Duration(days: 2)),
    timeSlot: '18:00 - 19:00',
    reservedBy: currentUser.name,
  ),
  Reserva(
    id: 'res2',
    pistaId: 'pista1',
    pistaName: 'Pista Central',
    date: DateTime.now().add(const Duration(days: 5)),
    timeSlot: '20:00 - 21:00',
    reservedBy: currentUser.name,
  ),
];

// Current logged-in user (Juan)
final Player currentUser = pJuan;
final Pair currentUserPair = pairJuanPedro;

// ───────────────────────── CHAT MESSAGES ─────────────────────────
final Map<String, List<ChatMessage>> mockChats = {
  'ch1': [
    ChatMessage(
      id: 'm1',
      senderId: pPam.id,
      senderName: pPam.name,
      text: 'Hola! El jueves a las 20:00 os viene bien?',
      timestamp: DateTime.now().subtract(const Duration(hours: 48)),
      avatarUrl: pPam.avatarUrl,
    ),
    ChatMessage(
      id: 'm2',
      senderId: pJuan.id,
      senderName: pJuan.name,
      text: 'Perfecto! Nos va genial.',
      timestamp: DateTime.now().subtract(const Duration(hours: 47)),
      avatarUrl: pJuan.avatarUrl,
    ),
    ChatMessage(
      id: 'm3',
      senderId: pPam.id,
      senderName: pPam.name,
      text: 'Perfecto! Nos vemos en la pista 3.',
      timestamp: DateTime.now().subtract(const Duration(hours: 47)),
      avatarUrl: pPam.avatarUrl,
    ),
    ChatMessage(
      id: 'm4',
      senderId: pJuan.id,
      senderName: pJuan.name,
      text: 'Allí estaremos. Traemos las pelotas 🎾',
      timestamp: DateTime.now().subtract(const Duration(hours: 46)),
      avatarUrl: pJuan.avatarUrl,
    ),
  ],
};
