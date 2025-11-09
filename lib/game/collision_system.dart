import 'core/rect_int.dart';
import 'entities/bullet.dart';
import 'entities/game_object.dart';
import 'entities/shield.dart';

class CollisionSystem {
  static bool overlaps(GameObject a, GameObject b) =>
      a.bounds.intersects(b.bounds);

  static bool bulletHitsShield(Bullet bullet, Shield shield) {
    if (shield.isDestroyed) return false;
    return overlaps(bullet, shield);
  }

  static RectInt combineBounds(Iterable<GameObject> objects) {
    final iterator = objects.iterator;
    if (!iterator.moveNext()) {
      return const RectInt(left: 0, top: 0, width: 0, height: 0);
    }
    var left = iterator.current.position.x;
    var top = iterator.current.position.y;
    var right = iterator.current.position.x + iterator.current.size.x;
    var bottom = iterator.current.position.y + iterator.current.size.y;
    while (iterator.moveNext()) {
      final obj = iterator.current;
      left = left < obj.position.x ? left : obj.position.x;
      top = top < obj.position.y ? top : obj.position.y;
      right = right > obj.position.x + obj.size.x
          ? right
          : obj.position.x + obj.size.x;
      bottom = bottom > obj.position.y + obj.size.y
          ? bottom
          : obj.position.y + obj.size.y;
    }
    return RectInt(
      left: left,
      top: top,
      width: right - left,
      height: bottom - top,
    );
  }
}
