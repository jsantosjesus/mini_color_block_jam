import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum DoorDirection { left, right, top, bottom }

class DoorComponent extends PositionComponent {
  final Color color;
  int gridX;
  int gridY;
  double sizeCell;
  DoorDirection direction;
  int sizeFactor; // fator de tamanho da porta
  final IconData icon; // ícone do Flutter

  DoorComponent({
    required this.color,
    required this.gridX,
    required this.gridY,
    required this.sizeFactor,
    this.icon = Icons.door_sliding_outlined, // ícone padrão
    required this.sizeCell,
    required this.direction,
  }) : super(size: _calculateSize(sizeFactor, sizeCell, direction));

  @override
  Future<void> onLoad() async {
    position = Vector2(gridX * sizeCell, gridY * sizeCell);
  }

  @override
  void render(Canvas canvas) {
    // Fundo da porta
    final paint = Paint()..color = color.withOpacity(0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)),
      paint,
    );

    // Borda
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)),
      border,
    );

    // ---- Desenha o ícone no centro ----
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: sizeCell * 0.6, // tamanho do ícone
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (size.x - textPainter.width) / 2,
      (size.y - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }
}

Vector2 _calculateSize(
  int sizeFactor,
  double sizeCell,
  DoorDirection direction,
) {
  switch (direction) {
    case DoorDirection.left:
    case DoorDirection.right:
      return Vector2(sizeCell, sizeCell * sizeFactor);
    case DoorDirection.top:
    case DoorDirection.bottom:
      return Vector2(sizeCell * sizeFactor, sizeCell);
  }
}
