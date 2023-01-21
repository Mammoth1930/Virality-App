import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/components.dart';
import 'package:viral_gamification_app/theme/constants.dart';
import 'package:viral_gamification_app/pages/models/crosswordmodel.dart';
import '../api/UserAPI.dart';
import '../providers/recharge_timer.dart';
import '../providers/user_provider.dart';
import 'crosswordpage.dart';
import 'home.dart';


class CrosswordSelectPage extends StatefulWidget {
  const CrosswordSelectPage({Key? key}) : super(key: key);

  @override
  State<CrosswordSelectPage> createState() => _CrosswordSelectPageState();
}

class _CrosswordSelectPageState extends State<CrosswordSelectPage> {

  void _rechargeEnd() {
    Provider.of<User>(context, listen: false).updateCrosswordRecharge(DateTime.now());
    Provider.of<User>(context, listen: false).addCrosswordRemaining(1);
    UserAPI.updateCrosswordRemaining(Provider.of<User>(context, listen: false)
        .crosswordRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).crosswordRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<RechargeTimer>(context, listen: false).reset(const Duration(hours: 24));
    }
  }

  void _catchup() {
    DateTime lastRecharge = Provider.of<User>(context, listen: false).lastCrosswordRecharge;
    while (lastRecharge.difference(DateTime.now()).inSeconds <= -86400 &&
        Provider.of<User>(context, listen: false).crosswordRemaining <
            Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<User>(context, listen: false).addCrosswordRemaining(1);
      lastRecharge = lastRecharge.add(const Duration(hours: 24));
    }
    Provider.of<User>(context, listen: false).updateCrosswordRecharge(lastRecharge);
    UserAPI.updateCrosswordRemaining(Provider.of<User>(context, listen: false)
        .crosswordRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).crosswordRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      if (lastRecharge.difference(DateTime.now()).inSeconds < 0) {
        lastRecharge = lastRecharge.add(const Duration(hours: 24));
      }
      Provider.of<RechargeTimer>(context, listen: false).initRechargeTimer(
          lastRecharge.difference(DateTime.now()), () => _rechargeEnd());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> completed = Provider.of<User>(context).completedCrosswords;
    if (context.watch<User>().crosswordRemaining < context.watch<User>().maxPuzzleCharges) {
      Duration nextRecharge = context.watch<User>().lastCrosswordRecharge.add(
          const Duration(hours: 24)).difference(DateTime.now()
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
          title: const Text("CROSSWORD SELECTION"),
          centerTitle: true,
          backgroundColor: Colors.black,
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
                            "Crossword energy: ${context.watch<User>().crosswordRemaining}",
                            style: Theme.of(context).textTheme.titleLarge
                        ),
                        Text(
                          context.watch<User>().crosswordRemaining >= Provider.of<User>(context, listen: false).maxPuzzleCharges?
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
              Text(
                "Crosswords",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  // Only print out if there are available crosswords and the
                  // user has energy
                    CrosswordList.length == completed.length? "" : context.watch<User>().crosswordRemaining == 0? "" : "Available",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    for (Crossword crossword in CrosswordList)
                      if (!completed.contains(crossword.title) && context.watch<User>().crosswordRemaining > 0)
                        SlantButton(
                            text: Text(crossword.title, style: Theme.of(context).textTheme.titleSmall),
                            colour: accentGreen,
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => CrosswordPage(crossword: crossword,)));
                            }
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  // Only show if the user has completed a crossword
                    completed.isEmpty? "" : "Review Completed Crosswords",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    for (Crossword crossword in CrosswordList)
                      if (completed.contains(crossword.title))
                        SlantButton(
                            text: Text(crossword.title, style: Theme.of(context).textTheme.titleSmall),
                            colour: accentLightGrey,
                            onPressed: () {
                              crossword.setCompleted(true);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => CrosswordPage(crossword: crossword,)));
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