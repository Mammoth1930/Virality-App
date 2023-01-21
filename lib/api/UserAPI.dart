import 'dart:collection';
import 'dart:convert';

import 'package:requests/requests.dart';

enum AuthReturnState {
  OK,
  DELETE_USER,
  AUTHENICATION_FAILED
}

class UserAPI {
  static const API_HOST = "deco3801-teamexe.uqcloud.net";
  // static const API_HOST = "10.0.2.2:80";
  static const API_ENDPOINT = "http://$API_HOST/api/v0";



  static Future<String?> createUser(String username, String uniqueifier) async {
    var res = await Requests.post("$API_ENDPOINT/user/new", body: {
      'username': username,
      'uniqueifier': uniqueifier,
    });
    dynamic jr = res.json();

    if (res.statusCode == 201) {
      if (jr["status"] == "Name Taken") {
        return null;
      }
    } else if (res.statusCode == 200 && jr["status"] == "OK") {
      return jr["loginToken"];
    } else {
      throw Exception("Unknown state when creating user: $res");
    }
    return null;
  }

  static Future<AuthReturnState> authenticate(String id) async {
    var res = await Requests.post("$API_ENDPOINT/user/auth", body: {
      'authentication': id,
    });
    if (res.hasError) {
      return AuthReturnState.AUTHENICATION_FAILED;
    }
    if (res.statusCode == 262) {//Special status code to indicate to delete the user token and go to register
      return AuthReturnState.DELETE_USER;
    }

    return AuthReturnState.OK;
  }

  static Future<dynamic> getUser() async {
    var res = await Requests.get("$API_ENDPOINT/user/info");
    if (res.statusCode == 200) {
      return res.json();
    }
    throw Exception("No user found: $res");
  }

  static Future<dynamic> fetchUserInfectionState() async {
    var res = await Requests.get("$API_ENDPOINT/user/infection/get");
    dynamic jr = res.json();
    if (res.statusCode == 200 && jr["status"] == "OK") {
      return jr;
    } else {
      throw Exception("Unknown state when getting user: ${res.statusCode}, ${jr["status"]}");
    }
  }

  static Future<dynamic> fetchCurrentDisease() async {
    var res = await Requests.get("$API_ENDPOINT/disease/current");
    dynamic jr = res.json();
    if (res.statusCode == 200 && jr["status"] == "OK") {
      return jr;
    } else {
      throw Exception("Unknown state when getting current disease: $res");
    }
  }

  static void setInfectionStatus(int status, int time) async {
    await Requests.post("$API_ENDPOINT/user/infection/set", body: {
      'time': time,
      'state': status,
    });
  }

  /// Gets the the completion progress of all vaccines and returns them as a
  /// HashMap with disease name as the key and progression as the value
  static Future<HashMap<String, double>> fetchVaccineProgressions() async {
    var res = await Requests.get("$API_ENDPOINT/disease/progress");
    dynamic jr = res.json();
    if (res.statusCode != 200 || jr["status"] != "OK") {
      throw Exception("There was an error getting the vaccine progresses: "
          "$res");
    } else {
      Map<String, dynamic> map = jsonDecode(res.body);
      return _mapFromJsonArray<double>(map["progresses"]);
    }
  }

  /// Gets the colour of each vaccine and returns them as a HashMap using the
  /// disease name as the key and the colour name from constants.dart as the
  /// value
  static Future<HashMap<String, String>> fetchVaccineColours() async {
    var res = await Requests.get("$API_ENDPOINT/disease/colours");
    dynamic jr = res.json();
    if (res.statusCode != 200 || jr["status"] != "OK") {
      throw Exception("There was an error getting the vaccine colours: $res");
    } else {
      Map<String, dynamic> map = jsonDecode(res.body);
      return _mapFromJsonArray<String>(map["colours"]);
    }
  }

  static void addResearch(String name, double amount) async {
    var res = await Requests.post("$API_ENDPOINT/disease/research/add", body: {
      'name': name,
      'amount': amount
    });
    if (res.statusCode != 200 || res.json()["status"] != "OK") {
      throw Exception("Unknown state when contributing research: $res");
    }
  }

  static void addPuzzlesCompleted() {
    Requests.post("$API_ENDPOINT/user/puzzle/add");
  }

  static void addScore(int amount) {
    Requests.post("$API_ENDPOINT/user/score/add", body: {
      'amount': amount
    });
  }

  static Future<String> getHint() async {
    var res = await Requests.get("$API_ENDPOINT/hint/get");
    if (res.statusCode != 200 || res.json()["status"] != "OK") {
      throw Exception("Unknown state when getting hint: $res");
    }
    return res.json()["hint"];
  }

  static Future<List<UserScore>> getTopScores() async {
    var res = await Requests.get("$API_ENDPOINT/scores/top/get");
    if (res.statusCode != 200) {
      throw Exception("Unknown state when getting scores: $res");
    }
    dynamic jr = res.json();
    List<UserScore> result = [];
    for (dynamic item in jr) {
      result.add(UserScore(item["user"], item["score"], item["image"]));
    }
    return result;
  }

  static Future<List<UserScore>> getScores() async {
    var res = await Requests.get("$API_ENDPOINT/user/scores");
    if (res.statusCode != 200) {
      throw Exception("Unknown state when getting scores: $res");
    }
    dynamic jr = res.json();
    List<UserScore> result = [];
    for (dynamic item in jr) {
      result.add(UserScore.withPos(item["user"], item["score"], item["pos"], item["image"]));
    }
    return result;
  }

  /// Converts a JSON object array in string format into a map
  /// String should be of the format [{'k1' : v1}, {'k2' : v2}]
  static HashMap<String, T> _mapFromJsonArray<T>(String str) {
    HashMap<String, T> result = HashMap();
    // Remove square brackets
    str = str.substring(1, str.length - 2);
    // Remove all quotes and curly braces
    str = str.replaceAll("{", "").replaceAll("}", "").replaceAll("'", "");
    // Split at comma
    List<String> objects = str.split(",");
    for (String object in objects) {
      List<String> elements = object.split(":");
      switch (T) {
        case double:
          result[elements.elementAt(0).trim()] = double.parse(elements.elementAt(1)) as T;
          break;
        case String:
          result[elements.elementAt(0).trim()] = elements.elementAt(1) as T;
          break;
        default:
          throw Exception("Invalid type T: $T");
      }
    }
    return result;
  }

  static Future<List<String>> fetchUserQuizzes() async {
      var res = await Requests.get("$API_ENDPOINT/quiz/completed/get");
      dynamic jr = res.json();
      if (res.statusCode != 200) {
        throw Exception("There was an error getting the users completed "
            "quizzes: $res");
      }
      List<String> out = [];
      for (dynamic i in jr) {
        out.add(i[0]);
      }
      return out;
  }

  static Future<List<String>> fetchUserCrosswords() async {
    var res = await Requests.get("$API_ENDPOINT/crossword/completed/get");
    dynamic jr = res.json();
    if (res.statusCode != 200) {
      throw Exception("There was an error getting the users completed "
          "crosswords: $res");
    }
    List<String> out = [];
    for (dynamic i in jr) {
      out.add(i[0]);
    }
    return out;
  }

  static void addQuizCompleted(String quiz) async {
    var res = await Requests.post(
      "$API_ENDPOINT/quiz/completed/add",
      body: {
        'quiz' : quiz
      }
    );
    if (res.statusCode != 200 || res.json()['status'] != "OK") {
      throw Exception("There was an error adding the current quiz: $res");
    }
  }

  static void addCrosswordCompleted(String crossword) async {
    var res = await Requests.post(
      "$API_ENDPOINT/crossword/completed/add",
      body: {
        'crossword' : crossword
      }
    );
    if (res.statusCode != 200 || res.json()['status'] != "OK") {
      throw Exception("There was an error adding the current crossword: $res");
    }
  }

  static void updateQuizRemaining(int newValue, int max) async {
    await Requests.post(
        "$API_ENDPOINT/quiz/remaining/update",
        body: {
          'amount' : newValue,
          'max' : max
        }
    );
  }

  static void updateDnaRemaining(int newValue, int max) async {
    await Requests.post(
        "$API_ENDPOINT/dna/remaining/update",
        body: {
          'amount' : newValue,
          'max' : max
        }
    );
  }

  static void updateCrosswordRemaining(int newValue, int max) async {
    await Requests.post(
        "$API_ENDPOINT/xword/remaining/update",
        body: {
          'amount' : newValue,
          'max' : max
        }
    );
  }

  static Future<String> getPFP() async {
    var res = await Requests.get("$API_ENDPOINT/pfp/get");
    if (res.statusCode != 200 || res.json()['status'] != "OK") {
      throw Exception("There was an error getting the profile picture: $res");
    }
    return res.json()["picture"];
  }

  static void setPFP(String username, String image) async {
    Requests.post("$API_ENDPOINT/pfp/set", body: {
      'username': username,
      'image': image
    });
  }

  static Future<int> getNumInfected() async {
    var res = await Requests.get("$API_ENDPOINT/num/infected");
    if (res.statusCode != 200 || res.json()['status'] != "OK") {
      throw Exception("There was an error getting the count: $res");
    }
    return int.parse(res.json()["num"]);
  }

  static Future<int> getSuccessfulRounds() async {
    var res = await Requests.get("$API_ENDPOINT/user/rounds");
    if (res.statusCode != 200 || res.json()['status'] != "OK") {
      throw Exception("There was an error getting the successful rounds: $res");
    }
    return int.parse(res.json()["rounds"]);
  }
}

class UserScore {
  int pos = 0;
  final String username;
  final int score;
  final String image;

  UserScore(this.username, this.score, this.image);
  UserScore.withPos(this.username, this.score, this.pos, this.image);

  @override
  String toString() {
    return "(#$pos $username: ${score.toString()}, $image)";
  }
}