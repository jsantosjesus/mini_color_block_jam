import 'package:flame/components.dart';

enum EnumComponentShape {
  square,
  lShape,
  tShape,
  zShape,
}


extension EnumComponentShapeExtension on EnumComponentShape {
  List<Vector2> get shape {
    switch (this) {
      case EnumComponentShape.square:
        return [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)];
      case EnumComponentShape.lShape:
        return [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)];
      case EnumComponentShape.tShape:
        return [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(1, 1)];
      case EnumComponentShape.zShape:
        return [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)];
    }
  }
}