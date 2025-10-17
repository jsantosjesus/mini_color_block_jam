import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_color_block_jam/components/block_component.dart';
import 'package:mini_color_block_jam/components/board_component.dart';
import 'package:mini_color_block_jam/components/border_component.dart';
import 'package:mini_color_block_jam/components/door_component.dart';
import 'package:mini_color_block_jam/funcoes/check_doors_collision.dart';

class ColorBlockJamGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  final int gridSize = 10;
  final double cellSize = 40;
  late List<BlockComponent> blocks;
  late List<DoorComponent> doors;
  BlockComponent? selectedBlock;

  @override
  Future<void> onLoad() async {
    final boardSize = cellSize * gridSize;

    // Define o tamanho visível da câmera
    camera.viewfinder.visibleGameSize = Vector2(boardSize, boardSize);

    // Faz o centro do tabuleiro ficar no meio da tela
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2(boardSize / 2, boardSize / 2);

    // Adiciona o fundo e os blocos
    add(BoardComponent(gridSize: gridSize, cellSize: cellSize));
    // Adiciona as bordas
    add(BorderComponent(gridSize: gridSize, cellSize: cellSize));

    blocks = [
      BlockComponent(color: Colors.red, gridX: 3, gridY: 1, sizeCell: cellSize),
      BlockComponent(
        color: Colors.green,
        gridX: 2,
        gridY: 3,
        sizeCell: cellSize,
      ),
      BlockComponent(
        color: Colors.blue,
        gridX: 5,
        gridY: 3,
        sizeCell: cellSize,
      ),
      BlockComponent(
        color: Colors.yellow,
        gridX: 5,
        gridY: 5,
        sizeCell: cellSize,
      ),
    ];

    for (final block in blocks) {
      add(block);
    }

    doors = [
      DoorComponent(
        color: Colors.red,
        gridX: 0,
        gridY: 2,
        sizeCell: cellSize,
      ), // esquerda
      DoorComponent(
        color: Colors.blue,
        gridX: 4,
        gridY: 0,
        sizeCell: cellSize,
      ), // direita
      DoorComponent(
        color: Colors.green,
        gridX: 9,
        gridY: 3,
        sizeCell: cellSize,
      ), // topo
      DoorComponent(
        color: Colors.yellow,
        gridX: 5,
        gridY: 9,
        sizeCell: cellSize,
      ), // fundo
    ];

    for (final door in doors) {
      add(door);
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    final touchPos = info.eventPosition.widget;
    for (final block in blocks) {
      if (block.toRect().contains(touchPos.toOffset())) {
        selectedBlock = block;
        block.isSelected = true; // ativa borda
        break;
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (selectedBlock == null) return;

    final delta = info.delta.global;
    final newPos = selectedBlock!.position + delta;

    // Mantém dentro dos limites do grid
    final min = 0.0;
    final max = cellSize * (gridSize - 1);
    final clampedX = newPos.x.clamp(min, max);
    final clampedY = newPos.y.clamp(min, max);

    final futureRect = Rect.fromLTWH(
      clampedX,
      clampedY,
      selectedBlock!.size.x,
      selectedBlock!.size.y,
    );

    // Verifica colisão com outros blocos
    final collided = blocks.any((block) {
      if (block == selectedBlock) return false;
      return futureRect.overlaps(block.toRect());
    });

    // if (!collided && checkBorderCollision(futureRect, selectedBlock!.color)) {
    if (!collided && checkBorderCollision(futureRect)) {
      selectedBlock!.position = Vector2(clampedX, clampedY);
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (selectedBlock == null) return;

    // Encaixa o bloco na célula mais próxima
    final snappedX = (selectedBlock!.position.x / cellSize).round().clamp(
      0,
      gridSize - 1,
    );
    final snappedY = (selectedBlock!.position.y / cellSize).round().clamp(
      0,
      gridSize - 1,
    );

    selectedBlock!
      ..gridX = snappedX
      ..gridY = snappedY
      ..position = Vector2(snappedX * cellSize, snappedY * cellSize);

    // Verifica se passou por uma porta
    checkDoorsCollision(selectedBlock, doors, this);

    // Caso não tenha passado por porta, desativa seleção
    if (selectedBlock != null) {
      selectedBlock!.isSelected = false;
      selectedBlock = null;
    }
  }

  // Função que só verifica colisão com as bordas
  bool checkBorderCollision(Rect futureRect) {
    // Verifica colisão com as bordas do tabuleiro
    for (int index = 0; index < gridSize; index++) {
      // Topo
      final topCell = Rect.fromLTWH(index * cellSize, 0, cellSize, cellSize);

      // Fundo
      final bottomCell = Rect.fromLTWH(
        index * cellSize,
        (gridSize - 1) * cellSize,
        cellSize,
        cellSize,
      );

      // Esquerda
      final leftCell = Rect.fromLTWH(0, index * cellSize, cellSize, cellSize);

      // Direita
      final rightCell = Rect.fromLTWH(
        (gridSize - 1) * cellSize,
        index * cellSize,
        cellSize,
        cellSize,
      );

      if (futureRect.overlaps(topCell) ||
          futureRect.overlaps(bottomCell) ||
          futureRect.overlaps(leftCell) ||
          futureRect.overlaps(rightCell)) {
        return false;
      }
    }

    return true; // sem colisão com borda ou está saindo por uma porta válida
  }

  // Função que verifica colisão com as bordas, permitindo passagem por portas da mesma cor
  final DoorComponent doorEmpity = DoorComponent(
    color: Colors.black,
    gridX: 3,
    gridY: 2,
    sizeCell: 80,
  );
  bool checkBorderCollisionWithDoors(Rect futureRect, Color blockColor) {
    // Verifica colisão com as bordas do tabuleiro
    for (int index = 0; index < gridSize; index++) {
      // Topo
      final topCell = Rect.fromLTWH(index * cellSize, 0, cellSize, cellSize);
      if (futureRect.overlaps(topCell)) {
        // há uma porta no topo dessa posição?
        final door = doors.firstWhere(
          (d) => d.color == blockColor && d.gridY == 0 && d.gridX == index,
          orElse: () => doorEmpity,
        );
        if (door == doorEmpity) return false; // sem porta da cor → colide
      }

      // Fundo
      final bottomCell = Rect.fromLTWH(
        index * cellSize,
        (gridSize - 1) * cellSize,
        cellSize,
        cellSize,
      );
      if (futureRect.overlaps(bottomCell)) {
        final door = doors.firstWhere(
          (d) =>
              d.color == blockColor &&
              d.gridY == gridSize - 1 &&
              d.gridX == index,
          orElse: () => doorEmpity,
        );
        if (door == doorEmpity) return false;
      }

      // Esquerda
      final leftCell = Rect.fromLTWH(0, index * cellSize, cellSize, cellSize);
      if (futureRect.overlaps(leftCell)) {
        final door = doors.firstWhere(
          (d) => d.color == blockColor && d.gridX == 0 && d.gridY == index,
          orElse: () => doorEmpity,
        );
        if (door == doorEmpity) return false;
      }

      // Direita
      final rightCell = Rect.fromLTWH(
        (gridSize - 1) * cellSize,
        index * cellSize,
        cellSize,
        cellSize,
      );
      if (futureRect.overlaps(rightCell)) {
        final door = doors.firstWhere(
          (d) =>
              d.color == blockColor &&
              d.gridX == gridSize - 1 &&
              d.gridY == index,
          orElse: () => doorEmpity,
        );
        if (door == doorEmpity) return false;
      }
    }

    return true; // sem colisão com borda ou está saindo por uma porta válida
  }
}
