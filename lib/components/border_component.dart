import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BorderComponent extends PositionComponent {
  final int gridSize;
  final double cellSize;

  BorderComponent({required this.gridSize, required this.cellSize});

  @override
  void render(Canvas canvas) {
    // Percorre as células do grid
    for (int index = 0; index < gridSize; index++) {
      addBorder(canvas: canvas, x: index, y: 0);
      addBorder(canvas: canvas, x: index, y: gridSize - 1);
      addBorder(canvas: canvas, x: 0, y: index);
      addBorder(canvas: canvas, x: gridSize - 1, y: index);
    }
    

  }

  void addBorder({required Canvas canvas, required int x, required int y}){
    final color =  Colors.grey[700]!;

        final paint = Paint()..color = color;
        final rect = Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);
            final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(0));

        canvas.drawRRect(rrect, paint);
  }
}
