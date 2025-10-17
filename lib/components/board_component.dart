import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BoardComponent extends Component {
  final int gridSize;
  final double cellSize;

  BoardComponent({required this.gridSize, required this.cellSize});

  @override
  void render(Canvas canvas) {
    // Percorre as células do grid (excluindo as bordas)
    for (int x = 1; x < gridSize -1; x++) {
      for (int y = 1; y < gridSize - 1; y++) {
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
