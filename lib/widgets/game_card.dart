import 'package:flutter/material.dart';
import 'package:gogdl_flutter/gogdl_flutter.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.imageBoxart,
    required this.sessionCode,
    required this.gameDetails,
    required this.onTapDownload,
  });
  final String imageBoxart;
  final String sessionCode;
  final GogDbGameDetails gameDetails;
  final Function(GogDbGameDetails gameDetails) onTapDownload;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageBoxart),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsets.all(8.5),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainer.withAlpha(128),
            ),
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.settings), onPressed: () {}),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    onTapDownload(gameDetails);
                  },
                ),
                IconButton(icon: Icon(Icons.play_arrow), onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
