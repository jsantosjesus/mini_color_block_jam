import 'dart:ui';

import 'package:mini_color_block_jam/components/door_component.dart';

bool checkDoorsCollisions(Rect futureRect, Color blockColor, List<DoorComponent> doors) {
    for (final door in doors) {
      final doorRect = door.toRect();

      if (futureRect.overlaps(doorRect) && door.color == blockColor) {
        return true;
      }
    }
    return false;
    }