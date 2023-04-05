import 'dart:async';

class PausablePeriodicTimer {
  final Duration duration;
  final void Function() callback;

  Timer? timer;

  PausablePeriodicTimer({required this.duration, required this.callback});

  start() {
    timer = Timer.periodic(duration, (_) => callback());
  }

  get isActive => timer == null ? false : timer?.isActive;

  pause() => cancel();

  cancel() {
    timer?.cancel();
  }
}
