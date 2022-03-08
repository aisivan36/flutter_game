import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/components/player.dart';
import 'package:flutter_game/components/world.dart';
import 'package:flutter_game/components/world_collidable.dart';
import 'package:flutter_game/helpers/direction.dart';
import 'package:flutter_game/helpers/map_loader.dart';

class RayWorldGame extends FlameGame with HasCollidables, KeyboardEvents {
  final Player _player = Player();
  final World _world = World();

  @override
  Future<void>? onLoad() async {
    await add(_world);
    add(_player);
    addWorldCollision();
    _player.position = _world.size / 2;
    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

    return super.onLoad();
  }

  void onJoypadDirectiononChanged(Direction direction) {
    _player.direction = direction;
  }

  void addWorldCollision() async {
    for (var element in (await MapLoader.readRayWorldCollisionMap())) {
      add(WorldCollidable()
        ..position = Vector2(element.left, element.top)
        ..width = element.width
        ..height = element.height);
    }
  }

  // Input Keyboard Events for the web
  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection;
    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      _player.direction = keyDirection;
    } else if (_player.direction == keyDirection) {
      _player.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
