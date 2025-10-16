import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BorderComponent extends PositionComponent {
  final int gridSize;
  final double cellSize;
  final double thickness;

  BorderComponent({
    required this.gridSize,
    required this.cellSize,
    this.thickness = 10,
  }) : super(size: Vector2(gridSize * cellSize + thickness*2, gridSize * cellSize + thickness*2));

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    canvas.drawRect(rect, paint);
  }
}
