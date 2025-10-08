import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/gogdl_flutter.dart';

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

  Stream<List<GogDbGameDetails>> getOwnedGames() {
    try {
      var games = gogGetOwnedGames(user: user!, downloader: gamesDownloader!);
      return games;
    } catch (e) {
      throw Exception('Failed to get owned games: $e');
    }
  }
}

final gogDlProvider = Provider<GogDl>((ref) => GogDl.initialize());
