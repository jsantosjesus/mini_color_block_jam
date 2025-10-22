import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mini_color_block_jam/components/enum_component_shape.dart';

class BlockComponent extends PositionComponent {
  final Color color;
  int gridX;
  int gridY;
  bool isSelected = false;
  final double sizeCell;

  /// Cada célula da forma, em coordenadas relativas
  final EnumComponentShape shape;

  BlockComponent({
    required this.color,
    required this.gridX,
    required this.gridY,
    required this.sizeCell,
    required this.shape,
  }) : super(
          size: _calculateSize(shape.shape, sizeCell),
        );

  static Vector2 _calculateSize(List<Vector2> shape, double cell) {
    // calcula o tamanho total do bloco com base na forma
    final maxX = shape.map((v) => v.x).reduce((a, b) => a > b ? a : b);
    final maxY = shape.map((v) => v.y).reduce((a, b) => a > b ? a : b);
    return Vector2((maxX + 1) * cell, (maxY + 1) * cell);
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(gridX * sizeCell, gridY * sizeCell);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = isSelected ? Colors.white : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // desenha cada célula da forma
    for (final cell in shape.shape) {
      final rect = Rect.fromLTWH(
        cell.x * sizeCell,
        cell.y * sizeCell,
        sizeCell,
        sizeCell,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
      canvas.drawRRect(rrect, paint);
      canvas.drawRRect(rrect, borderPaint);
    }
  }
}
