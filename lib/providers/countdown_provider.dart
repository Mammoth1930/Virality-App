import 'dart:async';

import 'package:flutter/material.dart';

/// Clock class
/// Contains logic for the doomsday timer on homepage of app
class Clock with ChangeNotifier {
  late DateTime _gameEnd; // DateTime of when the game will end
  late Duration _timeRemaining; // Time remaining till _gameEnd
  late Timer _timer;


  Clock() {
    updateGameEnd(getGameEnd());
    startTimer();
  }

  /// Intelligently finds the next game end which will be 00:00 of the
  /// closest Sunday
  DateTime getGameEnd() {
    DateTime today = DateTime.now();
    return today.add(
      Duration(
        days: ((DateTime.sunday - today.weekday) % DateTime.daysPerWeek),
        hours: 24 - today.hour - 1,
        minutes: 60 - today.minute - 1,
        seconds: 60 - today.second
      )
    );
  }

  /// Updates _gameEnd with a new value and adjusts _timeRemaining accordingly
  /// Params: newGameEnd - The new DateTime on which the game will end
  void updateGameEnd(DateTime newGameEnd) {
    _gameEnd = newGameEnd;
    _timeRemaining = _gameEnd.difference(DateTime.now());
    notifyListeners();
}

  void startTimer() => _timer = Timer.periodic(const Duration(seconds: 1),
          (_) => tick());

  void stopTimer() => _timer.cancel();

  /// Reduces _timeRemaining by one second and stops _timer once
  /// _timeRemaining < 0
  void tick() {
    final int seconds = _timeRemaining.inSeconds - 1;
    if (seconds < 0) {
      stopTimer();
      resetTimer(getGameEnd());
    } else {
      _timeRemaining = Duration(seconds: seconds);
    }
    notifyListeners();
  }

  /// Resets the timer to start counting down towards a new date
  /// params: newEndDate - The new DateTime the timer will begin counting
  /// towards
  void resetTimer(DateTime newEndDate) {
    stopTimer();
    updateGameEnd(newEndDate);
    startTimer();
  }

  // Getters
  DateTime get gameEnd => _gameEnd;
  Duration get timeRemaining => _timeRemaining;
  String get days => _timeRemaining.inDays.toString().padLeft(2, '0');
  String get hours => _timeRemaining.inHours.remainder(24).toString().padLeft(2, '0');
  String get minutes => _timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
  String get seconds => _timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');
}

