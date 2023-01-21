import 'dart:async';
import 'package:flutter/material.dart';

// RechargeTimer class
// Contains logic for the timer on when a new puzzle is available to the user
// Ignore that this is literally exactly the same as the QuizTimer
class RechargeTimer with ChangeNotifier {
  late Duration _timeRemaining;
  late Timer? _timer = null;
  late Function _onEnd;

  void initRechargeTimer(Duration duration, Function onEnd) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timeRemaining = duration;
    _onEnd = onEnd;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    final int seconds = _timeRemaining.inSeconds - 1;
    if (seconds < 0) {
      stopTimer();
    } else {
      _timeRemaining = Duration(seconds: seconds);
    }
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _onEnd();
  }

  void reset(Duration remaining) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timeRemaining = remaining;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  Duration get timeRemaining => _timeRemaining;
  Timer? get timer => _timer;
  String get hours => _timeRemaining.inHours.toString().padLeft(1, '0');
  String get minutes => _timeRemaining.inMinutes.remainder(60).toString().padLeft(2, "0");
  String get seconds => _timeRemaining.inSeconds.remainder(60).toString().padLeft(2, "0");
}