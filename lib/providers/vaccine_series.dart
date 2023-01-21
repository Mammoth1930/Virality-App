import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class VaccineSeries with ChangeNotifier {
  final String vaccineName; // Name of the vaccine
  int researchPercent; // Int from 0 to 100 representing total research
  // percentage of the vaccine
  late final charts.Color barColour; // Color of the bar in the chart
  final Color colour;

  VaccineSeries(this.vaccineName, this.researchPercent, this.colour)
      : barColour = charts.Color(r: colour.red, g: colour.green, b: colour.blue);

  // Setters
  set percent(int newPercentage) {
    researchPercent = newPercentage;
    notifyListeners();
  }

  // Getters
  String get name => vaccineName;
  int get percent => researchPercent;
}