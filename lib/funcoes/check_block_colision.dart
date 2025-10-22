import 'package:mini_color_block_jam/components/block_component.dart';
import 'package:mini_color_block_jam/components/enum_component_shape.dart';

bool checkBlockCollision(
  double clampedX,
  double clampedY,
  List<BlockComponent> blocks,
  BlockComponent selectedBlock,
) {
  bool collided = false;

  // calcula as células que o selectedBlock ocuparia na posição futura
  final double selectedCellSize = selectedBlock.sizeCell;
  final double selGridX = clampedX / selectedCellSize;
  final double selGridY = clampedY / selectedCellSize;

  final Set<String> selectedCells = <String>{};
  for (final cell in selectedBlock.shape.shape) {
    final int cx = (selGridX + cell.x).round();
    final int cy = (selGridY + cell.y).round();
    selectedCells.add('$cx,$cy');
  }

  // compara com as células ocupadas por cada outro bloco --
  for (final block in blocks) {
    if (block == selectedBlock) continue;

    // calcula o grid (pode estar entre células se block está sendo arrastado)
    final double otherCellSize = block.sizeCell;
    final double otherGridX = block.position.x / otherCellSize;
    final double otherGridY = block.position.y / otherCellSize;

    final Set<String> otherCells = <String>{};
    for (final cell in block.shape.shape) {
      final int cx = (otherGridX + cell.x).round();
      final int cy = (otherGridY + cell.y).round();
      otherCells.add('$cx,$cy');
    }

    // se houver interseção de células => colisão
    if (selectedCells.any((c) => otherCells.contains(c))) {
      collided = true;
      break;
    }
  }
  return collided;
}
