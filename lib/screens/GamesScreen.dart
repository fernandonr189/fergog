import 'package:fergog/provider/gog_provider.dart';
import 'package:fergog/widgets/GameCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key, required this.sessionCode});

  final String sessionCode;

  @override
  State<StatefulWidget> createState() {
    return _GamesScreenState();
  }
}

class _GamesScreenState extends State<GamesScreen> {
  final double tileWidth = 180;
  bool loggedIn = false;

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
            final gogDl = ref.watch(gogDlProvider);

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (await _login(gogDl)) {
                await gogDl.getUser();
                setState(() {
                  loggedIn = true;
                });
              }
            });

            return loggedIn
                ? FutureBuilder(
                    future: gogDl.getOwnedGames(),
                    initialData: <BigInt>[],
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<List<BigInt>> snapshot,
                        ) {
                          return GridView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) => GameCard(
                              gameId: snapshot.data?[index].toString() ?? "",
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
                        },
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
