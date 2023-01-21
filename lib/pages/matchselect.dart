import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/pages/match.dart';
import 'package:viral_gamification_app/pages/pages.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../api/UserAPI.dart';
import '../components.dart';
import '../providers/recharge_timer.dart';
import '../providers/user_provider.dart';

class MatchSelectPage extends StatefulWidget {
  const MatchSelectPage({Key? key}) : super(key: key);

  @override
  State<MatchSelectPage> createState() => _MatchSelectPageState();
}

class _MatchSelectPageState extends State<MatchSelectPage> {

  void _rechargeEnd() {
    Provider.of<User>(context, listen: false).updateDnaRecharge(DateTime.now());
    Provider.of<User>(context, listen: false).addDnaRemaining(1);
    UserAPI.updateDnaRemaining(Provider.of<User>(context, listen: false)
        .dnaRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).dnaRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<RechargeTimer>(context, listen: false).reset(const Duration(hours: 1));
    }
  }

  void _catchup() {
    DateTime lastRecharge = Provider.of<User>(context, listen: false).lastDnaRecharge;
    while (lastRecharge.difference(DateTime.now()).inSeconds <= -3600 &&
        Provider.of<User>(context, listen: false).dnaRemaining <
            Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      Provider.of<User>(context, listen: false).addDnaRemaining(1);
      lastRecharge = lastRecharge.add(const Duration(hours: 1));
    }
    Provider.of<User>(context, listen: false).updateDnaRecharge(lastRecharge);
    UserAPI.updateDnaRemaining(Provider.of<User>(context, listen: false)
        .dnaRemaining, Provider.of<User>(context, listen: false).maxPuzzleCharges);

    if (Provider.of<User>(context, listen: false).dnaRemaining <
        Provider.of<User>(context, listen: false).maxPuzzleCharges) {
      if (lastRecharge.difference(DateTime.now()).inSeconds < 0) {
        lastRecharge = lastRecharge.add(const Duration(hours: 1));
      }
      Provider.of<RechargeTimer>(context, listen: false).initRechargeTimer(
          lastRecharge.difference(DateTime.now()), () => _rechargeEnd());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (context.watch<User>().dnaRemaining < context.watch<User>().maxPuzzleCharges) {
      Duration nextRecharge = context.watch<User>().lastDnaRecharge.add(
          const Duration(hours: 1)).difference(DateTime.now()
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
        title: const Text("DNA SEQUENCING"),
        centerTitle: true,
        backgroundColor: backgroundBlack,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back
          ),
          onTap: () {
            Navigator.push(
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
                    children: <Widget> [
                      Text(
                        "Sequencing energy: ${context.watch<User>().dnaRemaining}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                          context.watch<User>().dnaRemaining > 4? "Maximum energy reached!" :
                          "Next recharge in ${context.watch<RechargeTimer>().hours}hrs "
                            "${context.watch<RechargeTimer>().minutes}min "
                            "${context.watch<RechargeTimer>().seconds}sec",
                        style: Theme.of(context).textTheme.titleMedium
                      )
                    ]
                  ),
                ),
              ),
            ),
            Center(
              child: SlantButton(
                text: Text(
                  "PLAY",
                  style: Theme.of(context).textTheme.titleLarge
                ),
                colour: context.watch<User>().dnaRemaining != 0 ? accentGreen : accentLightGrey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MatchPage(energyLeft: context.watch<User>().dnaRemaining != 0))
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
