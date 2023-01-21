import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/pages/models/questionmodel.dart';
import 'package:viral_gamification_app/pages/pages.dart';
import 'package:viral_gamification_app/pages/quizanswer.dart';
import 'package:viral_gamification_app/pages/vaccinecontribution.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../api/UserAPI.dart';
import '../providers/quiz_timer.dart';
import '../providers/user_provider.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizState();
}

class _QuizState extends State<QuizPage> {
  int _questionIndex = 0;
  bool answerSelected = false;
  int score = 0;
  int lastPoints = 0;

  @override
  void initState() {
    _initTimer(widget.quiz.questions[_questionIndex].time);
    super.initState();
  }

  void _nextQuestion() {
    // changes to next question after a 1.5 second delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Provider.of<QuizTimer>(context, listen: false).timer.cancel();
      setState(() {
        // Quiz finish
        if (_questionIndex + 1 == widget.quiz.questions.length) {
          // Quiz has already been completed OR round is over
          if (widget.quiz.completed || context.read<User>().success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const QuizSelectPage())
            );
            return;
          }
          // First time completing quiz
          _updateUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ContributionPage(quizName: widget.quiz.title, score: score)) // to account for longer quiz times
          );
          return;
        }
        _questionIndex++;
        answerSelected = false;
        Provider.of<QuizTimer>(context, listen: false).initQuizTimer(widget.quiz
            .questions[_questionIndex].time, () => _outOfTime());
      });
    });
  }

  void _questionAnswered(bool answerScore) {
    if (!mounted) return;
    Provider.of<QuizTimer>(context, listen: false).timer.cancel();
    setState(() {
      // answer was selected
      answerSelected = true;
      // check if answer was correct
      if (answerScore && !widget.quiz.completed) {
        lastPoints = 100 * Provider.of<QuizTimer>(context, listen: false).timeRemaining;
        score += lastPoints;
      } else {
        lastPoints = 0;
      }
    });
    _nextQuestion();
  }

  void _initTimer(Duration duration) {
    context.read<QuizTimer>().initQuizTimer(duration, () => _outOfTime());
  }

  void _outOfTime() {
    _questionAnswered(false);
  }

  void _updateUser() {
    Provider.of<User>(context, listen: false).addPuzzleCompleted();
    Provider.of<User>(context, listen: false).addToScore(score);
    Provider.of<User>(context, listen: false).addQuizCompleted(widget.quiz.title);
    if (Provider.of<User>(context, listen: false).quizzesRemaining ==
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<User>(context, listen: false).updateQuizRecharge(DateTime.now());
    }
    Provider.of<User>(context, listen: false).addQuizRemaining(-1);
    // Flush to database
    UserAPI.addQuizCompleted(widget.quiz.title);
    UserAPI.updateQuizRemaining(Provider.of<User>(context, listen: false)
        .quizzesRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);
    UserAPI.addPuzzlesCompleted();
    UserAPI.addScore(score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quiz.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          backgroundColor: backgroundBlack,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "TIME REMAINING: ${context.watch<QuizTimer>().timeRemaining}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "SCORE: $score",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
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
                              height: 130.0,
                              margin: const EdgeInsets.symmetric(horizontal: 30.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0
                              ),
                              decoration: BoxDecoration(
                                color: backgroundWhite,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Center(
                                child: Text(
                                  widget.quiz.questions[_questionIndex].text,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.merge
                                    (const TextStyle(color: textBlack))
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                              ...(widget.quiz.questions[_questionIndex].options).map(
                                    (answer) => QuizAnswer(
                                  answerText: answer.text,
                                  answerColor: answerSelected ? (answer.isCorrect ? Colors.green : Colors.red) : Colors.black,
                                  answerTapped: () {
                                    // if answer was already selected then nothing happens onTapped
                                    if (answerSelected) {
                                      return;
                                    }
                                    // answer is being selected
                                    _questionAnswered(answer.isCorrect);
                                    Future.delayed(const Duration(milliseconds: 500));
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 30.0)
                      ],
                    ),
                  ),
                  IgnorePointer( // Allows for child widget tree to be tapped through
                    ignoring: true,
                    child: Center(
                        child: AnimatedOpacity(
                          opacity: answerSelected && !widget.quiz.completed ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: backgroundDarkGrey,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "+$lastPoints",
                                style: Theme.of(context).textTheme.headlineLarge?.merge(
                                  TextStyle(
                                    // Changes the colour of the text depending on
                                    // how many points the user received.
                                    // < 1/3 = red, < 2/3 = orange and green otherwise
                                    color: lastPoints < (100 * widget.quiz
                                        .questions[_questionIndex].time.inSeconds)
                                      / 3? accentRed : lastPoints < 2 * ((100 * widget
                                        .quiz
                                        .questions[_questionIndex].time.inSeconds)
                                        / 3)? accentOrange : accentGreen
                                  )
                                )
                              ),
                            ),
                          ),
                        )
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}
