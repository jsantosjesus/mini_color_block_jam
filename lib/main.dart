import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_color_block_jam/game/fase_1.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.pink, // opcional, cor de fundo
        body: Center(
          child: SizedBox(
            width: 400, // mesmo tamanho total do tabuleiro (gridSize * cellSize)
            height: 400,
            child: GameWidget(game: ColorBlockJamGame()),
          ),
        ),
      ),
    ),
  );
}