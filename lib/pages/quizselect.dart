import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/api/UserAPI.dart';
import 'package:viral_gamification_app/components.dart';
import 'package:viral_gamification_app/pages/pages.dart';
import 'package:viral_gamification_app/theme/constants.dart';
import 'package:viral_gamification_app/pages/models/questionmodel.dart';
import '../providers/recharge_timer.dart';
import '../providers/user_provider.dart';

class QuizSelectPage extends StatefulWidget {
  const QuizSelectPage({Key? key}) : super(key: key);

  @override
  State<QuizSelectPage> createState() => _QuizSelectPageState();
}

class _QuizSelectPageState extends State<QuizSelectPage> {

  void _rechargeEnd() {
    Provider.of<User>(context, listen: false).updateQuizRecharge(DateTime.now());
    Provider.of<User>(context, listen: false).addQuizRemaining(1);
    UserAPI.updateQuizRemaining(Provider.of<User>(context, listen: false)
        .quizzesRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).quizzesRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<RechargeTimer>(context, listen: false).reset(const Duration(hours: 3));
    }
  }

  void _catchup() {
    DateTime lastRecharge = Provider.of<User>(context, listen: false).lastQuizRecharge;
    while (lastRecharge.difference(DateTime.now()).inSeconds <= -10800 &&
            Provider.of<User>(context, listen: false).quizzesRemaining <
            Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<User>(context, listen: false).addQuizRemaining(1);
      lastRecharge = lastRecharge.add(const Duration(hours: 3));
    }
    Provider.of<User>(context, listen: false).updateQuizRecharge(lastRecharge);
    UserAPI.updateQuizRemaining(Provider.of<User>(context, listen: false)
        .quizzesRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).quizzesRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      if (lastRecharge.difference(DateTime.now()).inSeconds < 0) {
        lastRecharge = lastRecharge.add(const Duration(hours: 3));
      }
      Provider.of<RechargeTimer>(context, listen: false).initRechargeTimer(
          lastRecharge.difference(DateTime.now()), () => _rechargeEnd());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> completed = Provider.of<User>(context).completedQuizzes;
    if (context.watch<User>().quizzesRemaining < context.watch<User>().maxPuzzleCharges) {
      Duration nextRecharge = context.watch<User>().lastQuizRecharge.add(
          const Duration(hours: 3)).difference(DateTime.now()
      );
      if (nextRecharge.inSeconds <= 0) {
        // User has been offline and now we need to update energy earned
        // passively
        _catchup();
      } else {
        Provider.of<RechargeTimer>(context, listen: false).initRechargeTimer
          (nextRecharge, () => _rechargeEnd());
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("QUIZ SELECTION"),
          centerTitle: true,
          backgroundColor: backgroundBlack,
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage())
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: backgroundDarkGrey,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Quiz energy: ${context.watch<User>().quizzesRemaining}",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        Text(
                          context.watch<User>().quizzesRemaining >= Provider.of<User>(context, listen: false).maxPuzzleCharges?
                            "Maximum energy reached!" :
                            "Next recharge in ${context.watch<RechargeTimer>().hours}hrs "
                                "${context.watch<RechargeTimer>().minutes}min "
                                "${context.watch<RechargeTimer>().seconds} sec",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  // Only print out if there are available quizzes and the
                  // user has quiz energy
                  quizList.length == completed.length? "" : context.watch<User>().quizzesRemaining == 0? "" : "Available",
                  style: Theme.of(context).textTheme.headlineSmall),
              ),
              Center(
                  child: Column(
                    children: <Widget>[
                      for (Quiz quiz in quizList)
                        if (!completed.contains(quiz.title) &&
                            context.watch<User>().quizzesRemaining > 0)
                          SlantButton(
                              text: Text(quiz.title, style: Theme.of(context).textTheme.titleSmall),
                              colour: accentGreen,
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) => QuizPage(quiz: quiz,)));
                              }
                          ),
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  // Only show if the user has completed a quiz
                  completed.isEmpty? "" : "Review Completed Quizzes",
                  style: Theme.of(context).textTheme.headlineSmall),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    for (Quiz quiz in quizList)
                      if (completed.contains(quiz.title))
                        SlantButton(
                            text: Text(quiz.title, style: Theme.of(context).textTheme.titleSmall),
                            colour: accentLightGrey,
                            onPressed: () {
                              quiz.setCompleted(true);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => QuizPage(quiz: quiz,)));
                            }
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0)
            ],
          ),
        )
    );
  }
}