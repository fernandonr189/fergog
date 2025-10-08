import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.imageBoxart,
    required this.sessionCode,
  });
  final String imageBoxart;
  final String sessionCode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(
                "https://images.gog-statics.com/$imageBoxart.jpg",
              ),
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
                IconButton(icon: Icon(Icons.arrow_downward), onPressed: () {}),
                IconButton(icon: Icon(Icons.play_arrow), onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
