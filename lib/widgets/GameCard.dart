import 'package:fergog/provider/gog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/src/rust/api/games_downloader.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.gameId, required this.sessionCode});

  final String gameId;
  final String sessionCode;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final ownedGames = ref.watch(
          gameDetailsProvider((sessionCode: sessionCode, gameId: gameId)),
        );
        return ownedGames.when(
          loading: () => SizedBox.shrink(),
          error: (err, _) => SizedBox.shrink(),
          data: (GogDbGameDetails data) {
            return data.productType == "game" && data.title != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    padding: EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Center(
                            child: data.imageBoxart != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      "https://images.gog-statics.com/${data.imageBoxart!}.jpg",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_downward),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          },
        );
      },
    );
  }
}
