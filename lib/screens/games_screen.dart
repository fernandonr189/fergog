import 'package:fergog/provider/gog_provider.dart';
import 'package:fergog/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/gogdl_flutter.dart';

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key, required this.sessionCode});

  final String sessionCode;

  @override
  ConsumerState<GamesScreen> createState() {
    return _GamesScreenState();
  }
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  final double tileWidth = 180;
  bool loggedIn = false;
  GogDl? gogDl;
  List<GogDbGameDetails> games = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      gogDl = ref.watch(gogDlProvider);
      if (await _login(gogDl!)) {
        await gogDl!.getUser();
        await gogDl!.getDownloader();
        games = await gogDl!.getOwnedGames();
        games = games.where((game) {
          var type = gogGetGameType(gameDetails: game);
          return type == "game";
        }).toList();
        setState(() {
          loggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Games"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return loggedIn
                ? GridView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) => GameCard(
                      imageBoxart: gogGetImageBoxart(gameDetails: games[index]),
                      sessionCode: widget.sessionCode,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (MediaQuery.of(context).size.width / tileWidth)
                              .toInt(),
                      childAspectRatio: 342 / 482,
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<bool> _login(GogDl gogDl) async {
    try {
      await gogDl.login(widget.sessionCode);
    } catch (e) {
      return false;
    }
    return true;
  }
}
