import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:viral_gamification_app/api/UserAPI.dart';
import 'package:viral_gamification_app/pages/crosswordselect.dart';
import 'package:viral_gamification_app/pages/matchselect.dart';

import 'package:viral_gamification_app/pages/pages.dart';
import 'package:viral_gamification_app/components.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../providers/user_provider.dart';
import '../providers/countdown_provider.dart';
import '../providers/vaccine_series.dart';

// Primary Widget for homepage containing the scaffold on which the page is
// build
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool success = false;
  int numInfected = 0;

  @override
  void initState() {
    getNumInfected();
    super.initState();
  }

  void getNumInfected() async {
    int tmp = await UserAPI.getNumInfected();
    setState(() {
      numInfected = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlack,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context){
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      // For developer mode
      endDrawer: Drawer(
        backgroundColor: backgroundDarkGrey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Toggle infected"),
              Switch(
                  value: context.watch<User>().state == UserState.infected,
                  onChanged: (bool newValue) =>
                  {
                    UserAPI.setInfectionStatus(UserState.infected.index, DateTime.now().millisecondsSinceEpoch ~/ 1000),
                    context.read<User>().setState
                      (newValue ? UserState.infected : UserState.healthy),
                  }
              )
            ]
        ),
      ),
      drawer: const Drawer(
        backgroundColor: backgroundDarkGrey,
        child: NavButtons()
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              success ? Text("VICTORY!!!", style: Theme.of(context).textTheme.headlineLarge,) : Container(),
              Text(success ? "NEXT ROUND IN" : "TIME REMAINING", style: Theme.of(context).textTheme.titleLarge),
              Text(
                "${context.watch<Clock>().days}:${context.watch<Clock>()
                    .hours}:${context.watch<Clock>().minutes}:${context.watch<Clock>().seconds}",
                style: Theme.of(context).textTheme.headlineLarge
                    ?.merge(TextStyle(fontFamily: "SevenSeg",
                    letterSpacing: 5.0, color: success ? accentGreen : Colors.white))
              ),
              Text(
                "DAYS:HOURS:MIN:SEC",
                style: Theme.of(context).textTheme.titleMedium
                    ?.merge(const TextStyle(letterSpacing: 2.5))
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: VaccineResearchProgress(setSuccess: () {
                  setState(() {
                    success = true;
                    context.read<User>().success = true;
                  });
                }),
              ), // Do NOT make this const
              success ? const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("The current round is over, but you can keep playing quizzes and puzzles to enhance your knowledge for the next round"),
              ) :
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("PLAYERS INFECTED: ", style: Theme.of(context).textTheme.titleMedium),
                        Text(numInfected.toString(), style: Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(color: accentRed))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("HEALTH STATUS: ", style: Theme.of(context).textTheme
                            .titleMedium),
                        Text(
                          // Get the user's state of infection
                          context.watch<User>().getStateAsString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.merge(TextStyle(
                                // Toggle text colour depending on state
                                // Red for infected, green for healthy and blue for
                                // immune
                                color: context.watch<User>().state == UserState.infected?
                                  accentRed : context.watch<User>().state == UserState.healthy?
                                  accentGreen : accentBlue
                          ))
                        )
                      ]
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: SlantButton(
                  height: 60,
                  width: 220,
                  text: Text("PLAY", style: Theme.of(context).textTheme.headlineSmall),
                  colour: accentOrange,
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Popup())
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Class containing the logic for the contents found inside of menu drawer on
// LHS of homepage
class NavButtons extends StatefulWidget {
  const NavButtons({Key? key}) : super(key: key);

  @override
  State<NavButtons> createState() => _NavButtonsState();
}

class _NavButtonsState extends State<NavButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          // Profile
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Profile picture
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/${context.watch<User>().pfp}"))
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        context.watch<User>().username,
                        style: Theme.of(context).textTheme.titleMedium
                      )
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: accentDarkGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      onPressed: () {
                        Navigator.push(
                          // page
                          context, MaterialPageRoute(builder: (_) => const ProfilePage())
                        );
                      },
                      child: Text(
                      "View Profile",
                      style: Theme.of(context).textTheme.titleSmall
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 40,
            thickness: 1,
            color: Colors.white
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const LeaderboardPage())
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.leaderboard_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 25),
                  Text(
                  "LEADERBOARD",
                  style: Theme.of(context).textTheme.titleSmall)
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 15,
            endIndent: 15,
            color: Colors.white
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ForumPage())
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 25),
                  Text(
                    "FORUM",
                    style: Theme.of(context).textTheme.titleSmall)
                ],
              ),
            ),
          ),
          const Divider(
              thickness: 1,
              indent: 15,
              endIndent: 15,
              color: Colors.white
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const GlossaryPage())
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.book_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 25),
                  Text(
                    "GLOSSARY",
                    style: Theme.of(context).textTheme.titleSmall)
                ],
              ),
            ),
          ),
          const Divider(
              thickness: 1,
              indent: 15,
              endIndent: 15,
              color: Colors.white
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const TutorialPage(auth: true))
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.help_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 25),
                  Text(
                      "TUTORIAL",
                      style: Theme.of(context).textTheme.titleSmall)
                ],
              ),
            ),
          ),
        ],
      );
  }
}


/// Class containing logic for the homepage graph showing the research
/// percentage of each vaccine
class VaccineResearchProgress extends StatefulWidget {
  final void Function() setSuccess;
  const VaccineResearchProgress({Key? key, required this.setSuccess}) : super(key: key);

  @override
  State<VaccineResearchProgress> createState() => _VaccineResearchProgressState();
}

class _VaccineResearchProgressState extends State<VaccineResearchProgress> {
  late HashMap<String, VaccineSeries> data;

  @override
  void initState() {
    data = HashMap();
    _loadVaccineProgressions();
    super.initState();
  }

  void _loadVaccineProgressions() async {
    HashMap<String, double> progressions = await UserAPI.fetchVaccineProgressions();
    HashMap<String, String> colours = await UserAPI.fetchVaccineColours();
    for (String vaccine in progressions.keys) {
      int percentage = (progressions[vaccine]! * 100).toInt();
      data[vaccine] = VaccineSeries(vaccine, percentage, strToColor
        (colours[vaccine]?.trim()));
    }
    String currentDisease = (await UserAPI.fetchCurrentDisease())["name"];
    if (progressions[currentDisease]! >= 1) {
      widget.setSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        domainFn: (VaccineSeries vacData, _) => vacData.name,
        measureFn: (VaccineSeries vacData, _) => vacData.percent,
        colorFn: (VaccineSeries vacData, _) => vacData.barColour,
        id: "Vaccines",
        data: data.values.toList(),
        labelAccessorFn: (VaccineSeries vacData, _) => vacData.percent.toString()
      )
    ];

    // Default text style for graph
    const charts.TextStyleSpec defaultText = charts.TextStyleSpec(
      color: charts.MaterialPalette.white,
      fontFamily: "ShareTech"
    );

    const charts.TextStyleSpec labelText = charts.TextStyleSpec(
      color: charts.MaterialPalette.white,
      fontFamily: "ShareTech",
      fontSize: 25
    );

    // Chart and axis titles
    List<charts.ChartTitle<String>> behaviors = [
      charts.ChartTitle(
        'Research Percentage',
        behaviorPosition: charts.BehaviorPosition.bottom,
        titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        titleStyleSpec: labelText
      ),
      charts.ChartTitle(
        'Vaccine Progress',
        behaviorPosition: charts.BehaviorPosition.top,
        titleStyleSpec: labelText
      )
    ];

    // Axis modifications
    // Y-axis
    const charts.OrdinalAxisSpec ordinalAxisSpec = charts.OrdinalAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        // Tick and label styling here
        labelStyle: defaultText,
        // Change the line colour
        lineStyle: charts.LineStyleSpec (
          color: charts.MaterialPalette.white
        )
      )
    );

    // X-axis
    // Set ticks for x-axis
    final staticTicks = <charts.TickSpec<num>> [
      const charts.TickSpec(0),
      const charts.TickSpec(20),
      const charts.TickSpec(40),
      const charts.TickSpec(60),
      const charts.TickSpec(80),
      const charts.TickSpec(100)
    ];

    charts.NumericAxisSpec numericAxisSpec = charts.NumericAxisSpec(
      renderSpec: const charts.GridlineRendererSpec(
        // Tick and label styling here
        labelStyle: defaultText,
        // Change the line colour
        lineStyle: charts.LineStyleSpec(
          color: charts.MaterialPalette.white
        )
      ),
      tickProviderSpec: charts.StaticNumericTickProviderSpec(staticTicks)
    );

    // Bar labels
    charts.BarLabelDecorator<String> barLabelDecorator = charts.BarLabelDecorator(
      insideLabelStyleSpec: const charts.TextStyleSpec(
        color: charts.MaterialPalette.black,
        fontFamily: "ShareTech"
      ),
      outsideLabelStyleSpec: defaultText,
      labelPosition: charts.BarLabelPosition.outside
    );

    // Build the chart widget
    charts.BarChart chart = charts.BarChart(
      series,
      animate: false,
      vertical: false,
      behaviors: behaviors,
      domainAxis: ordinalAxisSpec,
      primaryMeasureAxis: numericAxisSpec,
      barRendererDecorator: barLabelDecorator
    );

    // Return bar graph with some padding around the outside
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 200,
        child: chart
      ),
    );
  }
}

/// Creates a popup menu
class Popup extends StatelessWidget {
  const Popup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      backgroundColor: backgroundDarkGrey,
      contentPadding: const EdgeInsets.only(bottom: 10.0),
      content: Builder(
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          return SizedBox(
            height: 300,
            width: 0.9 * screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SlantButton(
                    text: Text("CROSSWORD", style: Theme.of(context).textTheme.headlineSmall),
                    colour: accentGreen,
                    width: 0.65 * screenWidth,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CrosswordSelectPage()));
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SlantButton(
                    text: Text("QUIZ", style: Theme.of(context).textTheme.headlineSmall),
                    colour: accentPurple,
                    width: 0.65 * screenWidth,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizSelectPage()));
                    },
                  ),
                ),
                SlantButton(
                  text: Text(
                    "DNA SEQUENCING",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  colour: accentCyan,
                  width: 0.65 * screenWidth,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchSelectPage()));
                  },
                )
              ],
            ),
          );
      }
      ),
    );
  }
}
