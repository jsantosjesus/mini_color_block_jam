import 'dart:ui';

/// 🔹 Verifica colisão com as bordas
  bool checkBorderCollision({required Rect futureRect, required Color blockColor, required int gridSize, required double cellSize}) {
    for (int index = 0; index < gridSize; index++) {
      // --- TOPO ---
      final topCell = Rect.fromLTWH(index * cellSize, 0, cellSize, cellSize);

      // --- FUNDO ---
      final bottomCell = Rect.fromLTWH(
        index * cellSize,
        (gridSize - 1) * cellSize,
        cellSize,
        cellSize,
      );

      // --- DIREITA ---
      final rightCell = Rect.fromLTWH(
        (gridSize - 1) * cellSize,
        index * cellSize,
        cellSize,
        cellSize,
      );

      // --- ESQUERDA ---
      final leftCell = Rect.fromLTWH(0, index * cellSize, cellSize, cellSize);

      if (futureRect.overlaps(topCell) ||
          futureRect.overlaps(bottomCell) ||
          futureRect.overlaps(leftCell) ||
          futureRect.overlaps(rightCell)) {
        return false;
      }
    }

    return true;
  }