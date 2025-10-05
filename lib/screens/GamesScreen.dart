import 'package:fergog/provider/gog_provider.dart';
import 'package:fergog/widgets/GameCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key, required this.sessionCode});

  final String sessionCode;
  final double tileWidth = 180;

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
            final ownedGames = ref.watch(ownedGamesProvider(sessionCode));

            return ownedGames.when(
              data: (list) => GridView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => GameCard(
                  gameId: list[index].toString(),
                  sessionCode: sessionCode,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / tileWidth).toInt(),
                  childAspectRatio: 2 / 3,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text("Error, ${err.toString()}")),
            );
          },
        ),
      ),
    );
  }
}
