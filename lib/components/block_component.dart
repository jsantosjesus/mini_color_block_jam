import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BlockComponent extends PositionComponent {
  final Color color;
  int gridX;
  int gridY;
  bool isSelected = false;
   double sizeCell;

  BlockComponent({
    required this.color,
    required this.gridX,
    required this.gridY,
    required this.sizeCell,
  }) : super(size: Vector2.all(sizeCell));

  @override
  Future<void> onLoad() async {
    position = Vector2(gridX * sizeCell, gridY * sizeCell);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6));

    canvas.drawRRect(rrect, paint);

    if (isSelected) {
      final border = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawRRect(rrect, border);
    }
  }
}
