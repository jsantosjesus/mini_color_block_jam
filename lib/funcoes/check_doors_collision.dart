import 'package:mini_color_block_jam/components/block_component.dart';
import 'package:mini_color_block_jam/components/door_component.dart';
import 'package:mini_color_block_jam/components/enum_component_shape.dart';

bool checkDoorsCollisions(BlockComponent block, List<DoorComponent> doors) {
  for (final door in doors) {
    if (door.color != block.color) continue;

    final doorRect = door.toRect();

    // posição base do bloco
    final baseX = block.position.x;
    final baseY = block.position.y;

    // dimensões em células
    final blockCells = block.shape.shape;

    // limites do bloco em células
    final minX = blockCells.map((c) => c.x).reduce((a, b) => a < b ? a : b);
    final maxX = blockCells.map((c) => c.x).reduce((a, b) => a > b ? a : b);
    final minY = blockCells.map((c) => c.y).reduce((a, b) => a < b ? a : b);
    final maxY = blockCells.map((c) => c.y).reduce((a, b) => a > b ? a : b);

    final blockWidth = (maxX - minX + 1) * block.sizeCell;
    final blockHeight = (maxY - minY + 1) * block.sizeCell;

    // agora verifica conforme o lado da porta
    switch (door.direction) {
      case DoorDirection.left:
        final alignedVertically =
            blockHeight <= doorRect.height &&
            baseY >= doorRect.top &&
            baseY + blockHeight <= doorRect.bottom;

        final touchingLeft =
            (baseX).round() == (doorRect.right).round(); // encostando na borda direita da porta

        if (alignedVertically && touchingLeft) return true;
        break;

      case DoorDirection.right:
        final alignedVertically =
            blockHeight <= doorRect.height &&
            baseY >= doorRect.top &&
            baseY + blockHeight <= doorRect.bottom;

        final touchingRight =
            (baseX + blockWidth).round() == (doorRect.left).round();

        if (alignedVertically && touchingRight) return true;
        break;

      case DoorDirection.top:
        final alignedHorizontally =
            blockWidth <= doorRect.width &&
            baseX >= doorRect.left &&
            baseX + blockWidth <= doorRect.right;

        final touchingTop =
            (baseY).round() == (doorRect.bottom).round();

        if (alignedHorizontally && touchingTop) return true;
        break;

      case DoorDirection.bottom:
        final alignedHorizontally =
            blockWidth <= doorRect.width &&
            baseX >= doorRect.left &&
            baseX + blockWidth <= doorRect.right;

        final touchingBottom =
            (baseY + blockHeight).round() == (doorRect.top).round();

        if (alignedHorizontally && touchingBottom) return true;
        break;
    }
  }

  return false;
}
