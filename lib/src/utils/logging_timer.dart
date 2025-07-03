import 'dart:developer' as dev;

class LoggingTimer {
  final watch = Stopwatch();
  final String name;
  bool stopped = false;
  LoggingTimer(this.name) {
    start();
  }
  LoggingTimer.stopped(this.name);

  void start() {
    dev.log("$name started");
    watch.start();
  }

  void log() {
    final ms = watch.elapsed.inMicroseconds / 1000;
    if (ms > 10_000) {
      dev.log("$name elapsed ${watch.elapsed.inMilliseconds / 1000}s");
    } else {
      dev.log("$name elapsed ${ms}ms");
    }
  }
}
