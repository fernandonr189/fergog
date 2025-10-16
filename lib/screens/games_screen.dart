import 'package:fergog/provider/gog_provider.dart';
import 'package:fergog/widgets/game_card.dart';
import 'package:fergog/widgets/game_download_modal.dart';
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
  Stream<List<GogDbGameDetails>> games = Stream.empty();
  List<({GogDbGameDetails details, String link})> gameDetails = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      gogDl = ref.watch(gogDlProvider);
      if (await _login(gogDl!)) {
        await gogDl!.getUser();
        await gogDl!.getDownloader();
        games = gogDl!.getOwnedGames();
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
                ? Stack(
                    children: [
                      StreamBuilder(
                        builder: (context, snap) {
                          if (!snap.hasError && snap.hasData) {
                            return GridView.builder(
                              itemCount: snap.data!.length,
                              itemBuilder: (context, index) => GameCard(
                                gameDetails: snap.data![index],
                                onTapDownload: (data) async {
                                  await _showDialog(context, data);
                                },
                                imageBoxart: gogGetImageBoxart(
                                  gameDetails: snap.data![index],
                                ),
                                sessionCode: widget.sessionCode,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (MediaQuery.of(context).size.width /
                                                tileWidth)
                                            .toInt(),
                                    childAspectRatio: 342 / 482,
                                  ),
                            );
                          } else if (snap.hasError) {
                            return Center(child: Text('Error: ${snap.error}'));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                        stream: games,
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                            itemCount: gameDetails.length,
                            itemBuilder: (context, index) {
                              var game = gameDetails[index];
                              return StreamBuilder(
                                stream: gogDl!.downloadGame(
                                  game.details,
                                  game.link,
                                ),
                                builder:
                                    (
                                      BuildContext context,
                                      AsyncSnapshot<DownloadProgress> snapshot,
                                    ) {
                                      if (snapshot.hasData &&
                                          !snapshot.hasError) {
                                        var progress = snapshot.data!;
                                        return ListTile(
                                          title: Text(
                                            gogGetGameTitle(
                                              gameDetails: game.details,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${progress.downloadProgress} / ${progress.totalBytes}',
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: Icon(Icons.arrow_downward),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, GogDbGameDetails data) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gogGetGameTitle(gameDetails: data)),
        content: GameDownloadModal(
          gameDetails: data,
          gameBuilds: gogDl!.getGameBuilds(gogGetGameId(gameDetails: data)),
          onTapDownload: (build) {
            setState(() {
              gameDetails.add((details: data, link: build));
            });
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
