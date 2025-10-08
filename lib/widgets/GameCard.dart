import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(
                "https://images.gog-statics.com/$imageBoxart.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsets.all(8),
        );
      },
    );
  }
}
