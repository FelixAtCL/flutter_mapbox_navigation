part of mapbox_navigation_flutter;

class DrivingSide {
  static const DrivingSide left = DrivingSide._('left');
  static const DrivingSide right = DrivingSide._('right');

  final String side;

  const DrivingSide._(this.side);

  static DrivingSide fromAndroid(Map<String, dynamic>? json) {
    if (json == null) return DrivingSide.right;

    return json['drivingSide'] == 'left' ? DrivingSide.left : DrivingSide.right;
  }

  static DrivingSide fromIOS(Map<String, dynamic>? json) {
    if (json == null) return DrivingSide.right;

    return json['drivingSide'] == 'left' ? DrivingSide.left : DrivingSide.right;
  }
}
