import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.gameId, required this.sessionCode});
  final String gameId;
  final String sessionCode;

  @override
  State<StatefulWidget> createState() {
    return _GameCardState();
  }
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Game Card: ${widget.gameId}'));
  }
}
