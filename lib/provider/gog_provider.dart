import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/src/rust/api/auth.dart';
import 'package:gogdl_flutter/src/rust/api/games_downloader.dart';

class GogProvider {
  GogProvider({required this.sessionCode});

  static Future<GogProvider> fromSessionCode(String code) async {
    GogProvider gogProvider = GogProvider(sessionCode: code);
    gogProvider.session = Session();
    gogProvider.session!.setSessionCode(sessionCode: code);
    await gogProvider.session?.login();

    gogProvider.gamesDownloader = GamesDownloader(
      session: gogProvider.session!,
    );

    return gogProvider;
  }

  Future<List<BigInt>> fetchOwnedGames() async {
    var list = await gamesDownloader!.fetchOwnedGameIds();
    return list.toList();
  }

  Future<GogDbGameDetails> fetchGameDetails(String gameId) async {
    var gameDetails = await gamesDownloader!.fetchGameDetails(gameId: gameId);
    return gameDetails;
  }

  final String sessionCode;
  GamesDownloader? _gamesDownloader;
  Session? _gogSession;

  set session(Session session) {
    _gogSession = session;
  }

  set gamesDownloader(GamesDownloader gamesDownloader) {
    _gamesDownloader = gamesDownloader;
  }

  Session? get session => _gogSession;
  GamesDownloader? get gamesDownloader => _gamesDownloader;
}

final gogProvider = FutureProvider.family<GogProvider, String>((
  ref,
  code,
) async {
  return await GogProvider.fromSessionCode(code);
});

final ownedGamesProvider = FutureProvider.family<List<BigInt>, String>((
  ref,
  code,
) async {
  final gog = await ref.watch(gogProvider(code).future);
  return gog.fetchOwnedGames();
});

final gameDetailsProvider =
    FutureProvider.family<
      GogDbGameDetails,
      ({String sessionCode, String gameId})
    >((ref, params) async {
      final gog = await ref.watch(gogProvider(params.sessionCode).future);
      return gog.fetchGameDetails(params.gameId);
    });
