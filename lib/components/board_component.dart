import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BoardComponent extends Component {
  final int gridSize;
  final double cellSize;

  BoardComponent({required this.gridSize, required this.cellSize});

  @override
  void render(Canvas canvas) {
    // Percorre as células do grid
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        // Alterna as cores, tipo tabuleiro de xadrez
        // final isEven = (x + y) % 2 == 0;
        final color =  Colors.grey[200]!;

        final paint = Paint()..color = color;
        final rect = Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);
            final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

        canvas.drawRRect(rrect, paint);

        // Desenha uma leve borda entre as células
        final border = Paint()
          ..color = Colors.pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawRect(rect, border);
      }
    }
  }
}
