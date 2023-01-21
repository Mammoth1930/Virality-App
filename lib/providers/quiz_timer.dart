import'dart:async';
import 'package:flutter/material.dart';

/// QuizTimer class
/// Contains logic for the timer on each quiz question
class QuizTimer with ChangeNotifier {
  late Duration _timeRemaining;
  late Timer _timer;
  late Function _onEnd;

  void initQuizTimer(Duration duration, Function onEnd) {
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
    _timer.cancel();
    _onEnd();
  }

  int get timeRemaining => _timeRemaining.inSeconds;
  Timer get timer => _timer;

}