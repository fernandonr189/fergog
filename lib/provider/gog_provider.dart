import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/src/rust/api/gogdl.dart';

class GogDl {
  final Session session;
  final Auth auth;
  User? user;
  GamesDownloader? gamesDownloader;

  GogDl(this.session, this.auth, this.user);
  factory GogDl.initialize() {
    Session newSession = gogInitialize();
    Auth newAuth = gogGetAuth(session: newSession);
    return GogDl(newSession, newAuth, null);
  }

  Future<void> login(String sessionCode) async {
    try {
      await gogLogin(auth: auth, sessionCode: sessionCode);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> getDownloader() async {
    try {
      GamesDownloader newDownloader = await gogGetDownloader(
        session: session,
        auth: auth,
      );
      gamesDownloader = newDownloader;
    } catch (e) {
      throw Exception('Failed to get downloader: $e');
    }
  }

  Future<void> getUser() async {
    try {
      User newUser = await gogGetUser(session: session, auth: auth);
      user = newUser;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<List<BigInt>> getOwnedGames() async {
    try {
      var games = await gogGetOwnedGames(user: user!);
      return games.toList();
    } catch (e) {
      throw Exception('Failed to get owned games: $e');
    }
  }

  Future<GogDbGameDetails> getGameDetails(String gameId) async {
    try {
      GogDbGameDetails details = await gogGetGameDetails(
        downloader: gamesDownloader!,
        gameId: gameId,
      );
      return details;
    } catch (e) {
      throw Exception('Failed to get game details: $e');
    }
  }
}

final gogDlProvider = Provider<GogDl>((ref) => GogDl.initialize());
