import 'dart:math';

import 'package:flutter/material.dart';
import 'package:viral_gamification_app/api/UserAPI.dart';
import 'package:viral_gamification_app/bluetooth.dart';

enum UserState {
  healthy,
  infected,
  immune
}

enum Role {
  doctor,
  epidemiologist,
  nurse
}

class User with ChangeNotifier {
  late String _username;
  late UserState _state;
  late Role _role;
  late DateTime _infectionTime;
  late String _diseaseName;
  late int _numPuzzlesCompleted;
  late int _roundsSurvived;
  late int _timesInfected = 0;
  late int _score;
  final List<String> _quizzesCompleted = [];
  late int _quizRemaining;
  late int _dnaRemaining;
  final List<String> _crosswordsCompleted = [];
  late int _crosswordRemaining;
  late DateTime _lastQuizRecharge;
  late DateTime _lastDnaRecharge;
  late DateTime _lastCrosswordRecharge;
  late String _pfp;

  bool success = false; // True when the game has been won
  final int MAX_PUZZLE_CHARGES = 5;

  void setupUserState(dynamic stats) async {
    _username = stats["username"];
    _infectionTime = intToTime(stats["infectionTime"]);
    _state = UserState.values[stats["state"]];
    _diseaseName = stats["disease"];
    _numPuzzlesCompleted = stats["puzzles"];
    _roundsSurvived = stats["roundsSurvived"];
    _timesInfected = stats["infectionCount"];
    _score = stats["score"];
    getRoleFromString(stats["role"]);
    _quizRemaining = stats["quizRemaining"];
    _dnaRemaining = stats["dnaRemaining"];
    _crosswordRemaining = stats["xWordRemaining"];
    _lastQuizRecharge = DateTime.fromMillisecondsSinceEpoch(stats["quizRechargeTime"].round() * 1000);
    _lastDnaRecharge = DateTime.fromMillisecondsSinceEpoch(stats["dnaRechargeTime"].round() * 1000);
    _lastCrosswordRecharge = DateTime.fromMillisecondsSinceEpoch(stats["crosswordRechargeTime"].round() * 1000);

    _pfp = await UserAPI.getPFP();
  }

  void getRoleFromString(String role) {
    switch (role) {
      case "doctor":
        _role = Role.doctor;
        break;
      case "nurse":
        _role = Role.nurse;
        break;
      default:
        _role = Role.epidemiologist;
    }
  }

  void updateBluetooth(UserState state) {
    switch (state) {
      case UserState.healthy:
        Bluetooth.stopDiscovering();
        Bluetooth.startAdvertising(setState);
        break;
      case UserState.infected:
        Bluetooth.stopAdvertising();
        Bluetooth.startDiscovering();
        break;
      case UserState.immune:
        Bluetooth.stopAdvertising();
        Bluetooth.stopDiscovering();
    }
  }

  DateTime stringToTime(String str) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(str) * 1000);
  }
  DateTime intToTime(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time*1000);
  }

  Future<void> setupInfectionState() async {
    var jr = await UserAPI.fetchUserInfectionState();

    int status = int.parse(jr["infection_status"]);
    switch (status) {
      case 0:
        _state = UserState.healthy;
        break;
      case 1:
        _state = UserState.infected;
        break;
      case 2:
        _state = UserState.immune;
        break;
      default:
        throw Exception("Unknown user state received from API");
    }
    _infectionTime = stringToTime(jr["infection_time"]);

    var currentDisease = await UserAPI.fetchCurrentDisease();

    Bluetooth.infectionProb = double.parse(currentDisease["infectionProb"]);

    if ((_state == UserState.infected || _state == UserState.immune) && DateTime.now().isAfter(_infectionTime.add(Duration(seconds: double.parse(currentDisease["immunityPeriod"]).toInt() + double.parse(currentDisease["duration"]).toInt())))) {
      setState(UserState.healthy);
      UserAPI.setInfectionStatus(UserState.healthy.index, _infectionTime.millisecondsSinceEpoch ~/ 1000); // leave the time alone
    } else if (_state == UserState.infected && DateTime.now().isAfter(_infectionTime.add(Duration(seconds: double.parse(currentDisease["duration"]).toInt())))) {
      setState(UserState.immune);
      UserAPI.setInfectionStatus(UserState.immune.index, _infectionTime.millisecondsSinceEpoch ~/ 1000); // leave the time alone
    } else {
      setState(_state); // just to trigger the BT and notify listeners
    }
  }

  // Setters

  void setState(UserState state) {
    _state = state;
    if (state == UserState.infected) {
      _timesInfected++;
    }
    notifyListeners();
    updateBluetooth(_state);
  }

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }

  void updateRounds() async {
    _roundsSurvived = await UserAPI.getSuccessfulRounds();
  }

  void addPuzzleCompleted() => _numPuzzlesCompleted++;
  void addToScore(int addition) => _score += addition;
  void addQuizCompleted(String title) => _quizzesCompleted.add(title);
  void addCrosswordCompleted(String title) => _crosswordsCompleted.add(title);
  void addQuizList(List<String> list) => _quizzesCompleted.addAll(list);
  void addCrosswordList(List<String> list) => _crosswordsCompleted.addAll(list);
  void updateQuizRecharge(DateTime time) => _lastQuizRecharge = time;
  void updateDnaRecharge(DateTime time) => _lastDnaRecharge = time;
  void updateCrosswordRecharge(DateTime time) => _lastCrosswordRecharge = time;

  // Adding to puzzle remaining counts, note they are all capped at a maximum
  // value of MAX_PUZZLE_CHARGES and a minimum of 0
  void addQuizRemaining(int addition) {
    _quizRemaining = max(0, min(_quizRemaining + addition, MAX_PUZZLE_CHARGES));
  }

  void addDnaRemaining(int addition) {
    _dnaRemaining = max(0, min(_dnaRemaining + addition, MAX_PUZZLE_CHARGES));
  }

  void addCrosswordRemaining(int addition) {
    _crosswordRemaining = max(0, min(_crosswordRemaining + addition, MAX_PUZZLE_CHARGES));
  }

    // Getters
    String get username => _username;
    UserState get state => _state;
    Role get role => _role;
    String? get disease => _diseaseName;
    int get puzzles => _numPuzzlesCompleted;
    int get rounds => _roundsSurvived;
    int get totalInfections => _timesInfected;
    int get score => _score;
    List<String> get completedQuizzes => _quizzesCompleted;
    List<String> get completedCrosswords => _crosswordsCompleted;
    int get quizzesRemaining => _quizRemaining;
    int get dnaRemaining => _dnaRemaining;
    int get crosswordRemaining => _crosswordRemaining;
    DateTime get lastQuizRecharge => _lastQuizRecharge;
    DateTime get lastDnaRecharge => _lastDnaRecharge;
    DateTime get lastCrosswordRecharge => _lastCrosswordRecharge;
    int get maxPuzzleCharges => MAX_PUZZLE_CHARGES;
    String get pfp => _pfp;

    String getStateAsString() {
      switch (state) {
        case UserState.healthy:
          return "HEALTHY";
        case UserState.infected:
          return "INFECTED";
        case UserState.immune:
          return "IMMUNE";
      }
    }

    String getRoleAsString() {
      switch (role) {
        case Role.doctor:
          return "DOCTOR";
        case Role.epidemiologist:
          return "EPIDEMIOLOGIST";
        case Role.nurse:
          return "NURSE";
      }
    }
  }