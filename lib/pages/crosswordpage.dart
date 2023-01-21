import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/components.dart';
import 'package:viral_gamification_app/pages/crosswordselect.dart';
import 'package:viral_gamification_app/pages/models/crosswordmodel.dart';
import 'package:viral_gamification_app/theme/constants.dart';
import 'package:viral_gamification_app/pages/vaccinecontribution.dart';

import '../api/UserAPI.dart';
import '../providers/user_provider.dart';
import '../theme/constants.dart';
import 'dart:async';

class CrosswordPage extends StatefulWidget {
  final Crossword crossword;

  const CrosswordPage({Key? key, required this.crossword}) : super(key: key);

  @override
  State<CrosswordPage> createState() => _CrosswordState();
}

class Cell {
  String letter;
  bool selected;
  int number;
  bool correct;

  Cell(this.letter, this.selected, this.number, this.correct);
}

class _CrosswordState extends State<CrosswordPage> {
  List<List<Cell>> userViewGrid = [[]];
  int time = 0;
  bool canCount = true;
  final fieldText = TextEditingController();
  int prevX = -1;
  int prevY = -1;
  bool prevHorizontal = false;
  late Word currentWord;
  bool somethingSelected = false;
  String errorText = "";
  bool gameOver = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _count();
    super.initState();
    initUserViewGrid();
  }

  @override
  void dispose() {
    canCount = false;
    super.dispose();
  }

  void _count() {
    if (!canCount) return;
    setState(() {time++;});
    Timer(const Duration(seconds: 1), () => {
      _count()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crossword.title),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _buildGameBody(),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = widget.crossword.xaxis;
    return Column(
      children: <Widget>[
        Expanded(child:
          ListView(
            controller: scrollController,
            children: [
              Row(
                children: <Widget>[
                  const Icon(Icons.timer),
                  Text(
                    " ${time.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0)
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridStateLength,
                    ),
                    itemBuilder: _buildGridItems,
                    itemCount: gridStateLength * gridStateLength,
                  ),
                ),
              ),
              Column(
                children: [
                  const Align(alignment: Alignment.centerLeft,child: Text("Across:"),),
                  Column(
                    children: [
                      for (Word word in widget.crossword.words)
                        if (!word.horizontal)
                          Align(alignment: Alignment.centerLeft,child: Text("${word.number}. ${word.clue}",),),
                    ],
                  ),
                  const Align(alignment: Alignment.centerLeft,child: Text("Down:"),),
                  Column(
                    children: [
                      for (Word word in widget.crossword.words)
                        if (word.horizontal)
                          Align(alignment: Alignment.centerLeft,child: Text("${word.number}. ${word.clue}"),),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SlantButton(
                      onPressed: () { _checkAnswer();},
                      text: Text(
                        "SUBMIT",
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                      colour: accentGreen,
                    ),
                  ),
                ],
              )
            ],
          )
        ),
        Row(
          children: [
            Flexible(
              child: TextField(
                controller: fieldText,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: errorText == "" ? null : errorText
                ),
                onSubmitted: (input) => {
                  enterWord(input.trim())
                },
                onEditingComplete: () {},
              ),
            ),
            MaterialButton(
              onPressed: () => {
                enterWord(fieldText.text)
              },
              color: accentBlue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ]
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = widget.crossword.yaxis;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              color: getColorForCell(userViewGrid[y][x]),
              border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    if (userViewGrid[y][x].letter == '0') {
      return const Text(' ');
    }
    else {
      return Wrap(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                    userViewGrid[y][x].number != -1 ? "${userViewGrid[y][x].number}" : "",
                    style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(
                      color: Colors.black,
                      height: 0.8
                    ))
                ),
              ),
              Align(
              alignment: Alignment.topCenter,
                child: Text(
                  userViewGrid[y][x].letter,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ]
      );
    }
  }

  Color getColorForCell(Cell cell) {
    if (cell.letter == '0') {
      return Colors.black;
    } else if (gameOver) {
      if (cell.correct) {
        return accentGreen;
      } else {
        return accentRed;
      }
    } else if (cell.selected) {
      return accentOrange;
    } else {
      return Colors.white;
    }
  }

  void enterWord(String input) {
    if (!somethingSelected) {
      setState(() {
        errorText = "Nothing selected";
      });
      return;
    }
    if (input.length != currentWord.word.length) {
      setState(() {
        errorText = "Invalid word length";
      });
      return;
    }
    if (input.contains((RegExp('[^a-zA-Z]')))) {
      setState(() {
        errorText = "Invalid characters in input";
      });
      return;
    }
    setState(() {
      errorText = "";
    });
    for (int i = 0; i < currentWord.word.length; i++) {
      setState(() {
        userViewGrid[currentWord.ypos + (currentWord.horizontal ? 0 : i)][currentWord.xpos + (currentWord.horizontal ? i : 0)].letter = input[i].toUpperCase();
      });
    }
    fieldText.clear();
  }

  void initUserViewGrid() {
    userViewGrid = widget.crossword.getAnswerGrid().map((row) => row.map((letter) => Cell(letter, false, -1, false)).toList()).toList();
    for (int i = 0; i < userViewGrid.length; i++) {
      for (int j = 0; j < userViewGrid[i].length; j++) {
        if (userViewGrid[j][i].letter != '0') {
          userViewGrid[j][i].letter = ' ';
        }
      }
    }
    for (Word word in widget.crossword.words) {
      userViewGrid[word.ypos][word.xpos].number = word.number;
    }
  }

  void _gridItemTapped(int x, int y) {

    // clear the old selection
    if (prevX != -1) { // if we have something selected
      int i = prevHorizontal ? prevX : prevY;
      while ((prevHorizontal ? prevY : i) <  userViewGrid.length
          && (prevHorizontal ? i : prevX) < userViewGrid[0].length
          && userViewGrid[prevHorizontal ? prevY : i][prevHorizontal ? i : prevX].letter != '0') {
        setState(() {
          userViewGrid[prevHorizontal ? prevY : i][prevHorizontal ? i : prevX].selected = false;
        });
        i++;
      }
    }
    setState(() {
      somethingSelected = false;
    });

    // find start of row/column where we tapped
    bool hasMoved = false;
    bool currentHorizontal = false;
    if (y > 0 && userViewGrid[y - 1][x].letter != '0') {
      currentHorizontal = true;
    }

    while ((currentHorizontal && y > 0 && userViewGrid[y - 1][x].letter != '0')
        || (!currentHorizontal && x > 0 && userViewGrid[y][x - 1].letter != '0')) {
      hasMoved = true;
      if (currentHorizontal) {
        y--;
      } else {
        x--;
      }
    }

    // select the row/column
    for (Word word in widget.crossword.words) {
      if (x == word.xpos && y == word.ypos && (word.horizontal != currentHorizontal || !hasMoved)) {
        for (int i = 0; i < word.word.length; i++) {
          setState(() {
            userViewGrid[y + (word.horizontal ? 0 : i)][x + (word.horizontal ? i : 0)].selected = true;
          });
        }
        setState(() {
          prevX = x;
          prevY = y;
          prevHorizontal = word.horizontal;
          currentWord = word;
          somethingSelected = true;
        });
        break;
      }
    }
  }

  void _checkAnswer() {
    if (gameOver) {
      return; // to not abuse points
    }

    int totalCells = 0;
    int correctCells = 0;
    // update colourings
    List<List<String>> answerGrid = widget.crossword.getAnswerGrid();
    for (int i = 0; i < userViewGrid.length; i++) {
      for (int j = 0; j < userViewGrid[i].length; j++) {
        if (userViewGrid[j][i].letter != '0') {
          if (userViewGrid[j][i].letter.toUpperCase() ==
              answerGrid[j][i].toUpperCase()) {
            correctCells++;
            setState(() {
              userViewGrid[j][i].correct = true;
            });
          }
          totalCells++;
        }
      }
    }

    setState(() {
      gameOver = true;
    });
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    if (widget.crossword.isComplete || context.read<User>().success) {
      Timer(const Duration(seconds: 3), () => {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CrosswordSelectPage())
        )
      });
      return;
    }

    // set crossword completion
    Provider.of<User>(context, listen: false).addCrosswordCompleted(widget.crossword.title);
    UserAPI.addCrosswordCompleted(widget.crossword.title);

    // get the score
    int score = ((400000 ~/ time) * (correctCells / totalCells)).toInt();
    UserAPI.addPuzzlesCompleted();
    UserAPI.addScore(score);
    context.read<User>().addPuzzleCompleted();
    context.read<User>().addToScore(score);

    // Modify energy
    if (Provider.of<User>(context, listen: false).crosswordRemaining == Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<User>(context, listen: false).updateCrosswordRecharge(DateTime.now());
    }
    Provider.of<User>(context, listen: false).addCrosswordRemaining(-1);
    UserAPI.updateCrosswordRemaining(Provider.of<User>(context, listen: false).crosswordRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    Timer(const Duration(seconds: 3), () => {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ContributionPage(quizName: widget.crossword.title, score: score))
      )
    });
  }
}