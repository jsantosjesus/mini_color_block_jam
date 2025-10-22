import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_color_block_jam/components/block_component.dart';
import 'package:mini_color_block_jam/components/board_component.dart';
import 'package:mini_color_block_jam/components/border_component.dart';
import 'package:mini_color_block_jam/components/door_component.dart';
import 'package:mini_color_block_jam/components/enum_component_shape.dart';
import 'package:mini_color_block_jam/funcoes/check_block_colision.dart';
import 'package:mini_color_block_jam/funcoes/check_border_collision.dart';
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
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2(boardSize / 2, boardSize / 2);

    // Fundo e bordas
    add(BoardComponent(gridSize: gridSize, cellSize: cellSize));
    add(BorderComponent(gridSize: gridSize, cellSize: cellSize));

    // Blocos
    blocks = [
      // Bloco quadrado 1x1
      BlockComponent(
        color: Colors.red,
        gridX: 1,
        gridY: 1,
        sizeCell: cellSize,
        shape: EnumComponentShape.square,
      ),

      // Bloco retangular 2x1
      BlockComponent(
        color: Colors.blue,
        gridX: 3,
        gridY: 1,
        sizeCell: cellSize,
        shape: EnumComponentShape.lShape,
      ),

      // Bloco em "L"
      // BlockComponent(
      //   color: Colors.green,
      //   gridX: 2,
      //   gridY: 2,
      //   sizeCell: cellSize,
      //   shape: EnumComponentShape.tShape,
      // ),

      // Bloco em "Z"
      BlockComponent(
        color: Colors.yellow,
        gridX: 4,
        gridY: 4,
        sizeCell: cellSize,
        shape: EnumComponentShape.zShape,
      ),

      // Bloco em "T"
      BlockComponent(
        color: Colors.green,
        gridX: 6,
        gridY: 6,
        sizeCell: cellSize,
        shape: EnumComponentShape.tShape,
      ),
    ];

    for (final block in blocks) {
      add(block);
    }

    // Portas
    doors = [
      DoorComponent(
        color: Colors.red,
        gridX: 0,
        gridY: 2,
        sizeCell: cellSize,
        direction: DoorDirection.left,
        sizeFactor: 2,
      ), // esquerda
      DoorComponent(
        color: Colors.blue,
        gridX: 9,
        gridY: 3,
        sizeCell: cellSize,
        direction: DoorDirection.right,
        sizeFactor: 2,
      ), // direita
      DoorComponent(
        color: Colors.green,
        gridX: 4,
        gridY: 0,
        sizeCell: cellSize,
        direction: DoorDirection.top,
        sizeFactor: 3,
      ), // topo
      DoorComponent(
        color: Colors.yellow,
        gridX: 5,
        gridY: 9,
        sizeCell: cellSize,
        direction: DoorDirection.bottom,
        sizeFactor: 3,
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
        block.isSelected = true;
        break;
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (selectedBlock == null) return;

    final delta = info.delta.global;
    final newPos = selectedBlock!.position + delta;

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

    if (checkDoorsCollisions(selectedBlock!, doors)) {
      // Move o bloco para fora do tabuleiro
      // selectedBlock!.position = Vector2(-100, -100);
      // Remove o bloco da lista e do jogo
      remove(selectedBlock!);
      // Remove o bloco da lista
      blocks.remove(selectedBlock);
      // Desativa seleção
      selectedBlock!.isSelected = false;
      selectedBlock = null;
      return;
    }

    // colisão por células considerando shape de cada bloco
    bool collided = checkBlockCollision(clampedX, clampedY, blocks, selectedBlock!);

    // Verifica se pode mover (sem colisão e respeitando bordas/portas)
    if (!collided &&
        checkBorderCollision(
          futureRect: futureRect,
          blockColor: selectedBlock!.color,
          gridSize: gridSize,
          cellSize: cellSize,
        )) {
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

    // Desativa seleção
    selectedBlock!.isSelected = false;
    selectedBlock = null;
  }
}
