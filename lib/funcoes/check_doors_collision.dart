import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_color_block_jam/components/block_component.dart';
import 'package:mini_color_block_jam/components/door_component.dart';

void checkDoorsCollision(
    BlockComponent? selectedBlock, List<DoorComponent> doors, FlameGame game) {
  if (selectedBlock == null) return;

  final blockRect = selectedBlock.toRect();

  for (final door in doors) {
    final doorRect = door.toRect();

    // Se o bloco sobrepõe a porta e tem a mesma cor
    if (blockRect.overlaps(doorRect) && selectedBlock?.color == door.color) {
      // animação de sumir
      selectedBlock?.add(
        ScaleEffect.to(
          Vector2.zero(),
          EffectController(duration: 0.2, curve: Curves.easeIn),
          onComplete: () {
            // game.remove(selectedBlock);
          },
        ),
      );

      // remove a referência do bloco selecionado imediatamente
      selectedBlock = null;
      break;
    }
  }
}
