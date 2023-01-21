import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../api/UserAPI.dart';
import '../providers/user_provider.dart';
import '../providers/vaccine_series.dart';
import 'home.dart';

class ContributionPage extends StatefulWidget {
  final String quizName;
  final int score;

  const ContributionPage({Key? key, required this.quizName, required this.score}) : super(key: key);

  @override
  State<ContributionPage> createState() => _ContributionPageState();
}

class _ContributionPageState extends State<ContributionPage> {
  List<VaccineSeries> vaccineData = [];
  double contributionAmount = 0;
  String hint = "";
  bool contributed = false;

  @override
  void initState() {
    _getHint();
    _loadVaccineProgressions();
    setState(() => {
      contributionAmount = Provider.of<User>(context, listen: false).state ==
          UserState.infected? (max(min(widget.score / 150000, 0.05), 0.01))/2 :
          max(min(widget.score / 150000, 0.05), 0.01)
    });
    super.initState();
  }

  void _getHint() async {
    String tmp = await UserAPI.getHint();
    setState(() {
      hint = tmp;
    });
  }

  void _loadVaccineProgressions() async {
    vaccineData = [];
    HashMap<String, double> progressions = await UserAPI.fetchVaccineProgressions();
    HashMap<String, String> colours = await UserAPI.fetchVaccineColours();
    for (String vaccine in progressions.keys) {
      int percentage = (progressions[vaccine]! * 100).toInt();
      setState(() {
        vaccineData.add(VaccineSeries(vaccine, percentage, strToColor
          (colours[vaccine]?.trim())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quizName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: backgroundBlack,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Image(
                      image: AssetImage("images/PurpleVirus.jpg")),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0
                  ),
                  decoration: BoxDecoration(
                    color: backgroundLightGrey,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: backgroundWhite,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            "YOU SCORED:\n${widget.score}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.merge(const TextStyle(color: textBlack)),
                          ),
                        ),
                        Text(
                            "CONGRATULATIONS!",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.merge
                              (const TextStyle(color: textBlack))
                        ),
                        Text(
                            "Please choose a vaccine to contribute research to",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.merge
                              (const TextStyle(color: textBlack))
                        ),
                      ]
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundDarkGrey,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(
                "YOU HAVE ${(contributionAmount * 100).toStringAsFixed(2)}% TO CONTRIBUTE...",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundDarkGrey,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(
                  "HINT FOR SECRET DISEASE:\n$hint",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.merge
                    (const TextStyle(color: textWhite))
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundDarkGrey,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  children: vaccineData.map((vaccData) =>
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith((states) => const Size(double.infinity, 10)),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => accentDarkGrey),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                            ),
                          ),
                          onPressed: () {
                            if (!contributed) {
                              contributed = true;
                              // send API request to contribute research
                              UserAPI.addResearch(vaccData.vaccineName, contributionAmount);
                              // update user if the game was completed
                              Provider.of<User>(context, listen: false).updateRounds();
                              // Update display and local progress tracker
                              setState(() {
                                min(vaccData.percent + contributionAmount, 100);
                              });
                              // wait 1 second
                              // go to home
                              Timer(const Duration(seconds: 1), () =>
                              {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomePage())
                                )
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    vaccData.vaccineName,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(const TextStyle(
                                        color: Colors.white
                                    ))
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: vaccData.percent / 100,
                                        color: vaccData.colour,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          "${vaccData.percent}%",
                                          style: TextStyle(color: vaccData.colour)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ).toList(),
                )
            )
          ],
        ),
      ),
    );
  }
}