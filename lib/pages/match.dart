import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/pages/matchselect.dart';
import 'package:viral_gamification_app/pages/vaccinecontribution.dart';

import '../api/UserAPI.dart';
import '../providers/user_provider.dart';
import '../theme/constants.dart';

class MatchPage extends StatefulWidget {
  final bool energyLeft;

  const MatchPage({Key? key, required this.energyLeft}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchState();
}

class Letter {
  String letter;
  bool revealed;

  Letter(this.letter, this.revealed);
}

class _MatchState extends State<MatchPage> {
  List<String> order = [];
  List<List<Letter>> letters = [];
  int lettersClicked = 0;
  late Letter prevLetter;
  int position = 0;
  bool clickDisabled = false;
  int time = 0;
  bool canCount = true;
  bool showHelp = false;

  @override
  void initState() {
    var random = Random();
    // generate list of 9 letters
    for (int i = 0; i < 9; i++) {
      setState(() {
        order.add(["G", "C", "A", "T"][random.nextInt(4)]);
      });
    }
    // generate list of letters that will appear on the board
    List<String> appears = order + order;
    for (int i = 0; i < 6; i++) {
      List<Letter> row = [];
      for (int j = 0; j < 3; j++) {
        row.add(Letter(appears.removeAt(random.nextInt(appears.length)), false));
      }
      setState(() {
        letters.add(row);
      });
    }
    _count();
    super.initState();
  }

  @override
  void dispose() {
    canCount = false;
    super.dispose();
  }

  void _count() {
    if (!canCount) return;
    setState(() { time++; });
    Timer(const Duration(seconds: 1), () => {
      _count()
    });
  }
  
  Color _colorForLetter(String l) {
    switch(l) {
      case "G":
        return accentOrange;
      case "C":
        return accentBlue;
      case "A":
        return accentPurple;
      case "T":
        return accentGreen;
      default:
        return accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "DNA SEQUENCING"
        ),
        backgroundColor: backgroundBlack,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(children: [const Icon(Icons.timer), Text(" ${time.toString()}")]),
                  ),
                  IconButton(onPressed: () {
                    setState(() {
                      showHelp = !showHelp;
                    });
                  }, icon: const Icon(Icons.help))
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundWhite,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: backgroundLightGrey, width: 5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: order.asMap().entries.map((l) =>
                    Text(
                      l.value,
                      style: TextStyle(
                        color: l.key >= position ? _colorForLetter(l.value) : accentDarkGrey
                      ),
                    )
                  ).toList(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: backgroundLightGrey,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: letters.map((row) =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: row.map((letter) =>
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() {
                                  if (clickDisabled) return;
                                  if (letter.revealed) return;
                                  if (lettersClicked == 0) {
                                    prevLetter = letter;
                                    lettersClicked = 1;
                                    letter.revealed = true;
                                  } else if (lettersClicked == 1 && letter != prevLetter) {
                                    if (letter.letter == prevLetter.letter && letter.letter == order[position]) {
                                      position++;
                                      if (position == 9) {
                                        int score = 225000 ~/ time;
                                        UserAPI.addPuzzlesCompleted();
                                        UserAPI.addScore(score);
                                        context.read<User>().addPuzzleCompleted();
                                        context.read<User>().addToScore(score);
                                        // Energy recharge logic
                                        if (Provider.of<User>(context, listen: false).dnaRemaining == Provider.of<User>(context, listen: false).maxPuzzleCharges) {
                                          Provider.of<User>(context, listen: false).updateDnaRecharge(DateTime.now());
                                        }
                                        Provider.of<User>(context, listen: false).addDnaRemaining(-1);
                                        UserAPI.updateDnaRemaining(Provider.of<User>(context, listen: false).dnaRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => context.read<User>().success || !widget.energyLeft ? const MatchSelectPage() : ContributionPage(quizName: "DNA SEQUENCING", score: score))
                                        );
                                      }
                                      letter.revealed = true;
                                    } else {
                                      letter.revealed = true;
                                      clickDisabled = true;
                                      Timer(const Duration(seconds: 1), () =>
                                      { // let the user see the tile for a second
                                        setState(() =>
                                        {
                                          prevLetter.revealed = false,
                                          letter.revealed = false,
                                          clickDisabled = false
                                        })
                                      });
                                    }
                                    lettersClicked = 0;
                                  }
                                }),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: letter.revealed ? _colorForLetter(letter.letter) : backgroundDarkGrey,
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(color: backgroundWhite, width: 5)
                                    ),
                                    child: Text(
                                        letter.revealed ? letter.letter : "",
                                      style: Theme.of(context).textTheme.displayLarge,
                                    ),
                                  ),
                                ),
                              )
                            )
                          ).toList(),
                        )
                      ).toList()
                    ),
                  ),
                ),
              ),
            ]
          ),
          showHelp ? Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: MaterialButton(
                  onPressed: () { setState(() {
                    showHelp = false;
                  }); },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: backgroundDarkGrey,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: backgroundWhite, width: 5)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close, size: 40),
                        Text(
                            "The classic memory matching game, with a twist!\n"
                            "Find pairs of matching letters, but reveal them in the order indicated at the top of the screen.\n"
                            "The faster you complete the puzzle, the higher your score will be.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ) : Container(),
        ],
      )
    );
  }
}
