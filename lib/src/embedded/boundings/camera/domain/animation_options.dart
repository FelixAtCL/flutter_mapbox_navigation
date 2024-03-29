part of mapbox_navigation_flutter;

class MapAnimationOptions {
  MapAnimationOptions({
    this.duration,
    this.startDelay,
  });

  /// The duration of the animation in milliseconds.
  /// If not set explicitly default duration will be taken 300ms
  int? duration;

  /// The amount of time, in milliseconds, to delay starting the animation after animation start.
  /// If not set explicitly default startDelay will be taken 0ms. This only works for Android.
  int? startDelay;

  Object encode() {
    return <Object?>[
      duration,
      startDelay,
    ];
  }

  static MapAnimationOptions decode(Object result) {
    result as List<Object?>;
    return MapAnimationOptions(
      duration: result[0] as int?,
      startDelay: result[1] as int?,
    );
  }
}
