import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/theme/constants.dart';

import '../api/UserAPI.dart';
import '../providers/user_provider.dart';
import '../theme/constants.dart';
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<UserScore> topScores = [UserScore("", 0, "pfp1.png"), UserScore("", 0, "pfp1.png"), UserScore("", 0, "pfp1.png")];
  List<UserScore> otherScores = [];


  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() async {
    List<UserScore> tmp1 = await UserAPI.getTopScores();
    List<UserScore> tmp2 = await UserAPI.getScores();
    setState(() {
      topScores = tmp1;
      while (topScores.length < 3) {
        topScores.add(UserScore("", 0, "pfp1.png"));
      }
      otherScores = tmp2;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LEADERBOARD",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: backgroundBlack,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Second place
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            topScores[1].username,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Text(
                          "2nd",
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("images/${topScores[1].image}"))
                          ),
                          height: 80.0,
                          width: 80.0,
                        ),
                        Text(
                          topScores[1].score.toString(),
                          style: Theme.of(context).textTheme.labelLarge
                        ),
                      ],
                    ),
                  ),
                  // First place
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            topScores[0].username,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Text(
                            "1st",
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("images/${topScores[0].image}"))
                          ),
                          width: 100,
                          height: 100,
                        ),
                        Text(
                            topScores[0].score.toString(),
                            style: Theme.of(context).textTheme.labelLarge
                        ),
                      ],
                    ),
                  ),
                  // Third place
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            topScores[2].username,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Text(
                            "3rd",
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("images/${topScores[2].image}"))
                          ),
                          height: 80.0,
                          width: 80.0,
                        ),
                        Text(
                            topScores[2].score.toString(),
                            style: Theme.of(context).textTheme.labelLarge
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20),

                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: accentDarkGrey,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    width: screenWidth,
                    // height: screenHeight,

                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: otherScores.map((userScore) =>
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: userScore.username == context.read<User>().username ? accentOrange : accentDarkGrey, // get user provider check if name is equal make orange
                                borderRadius: BorderRadius.circular(20)
                            ),
                            height: 70,
                            width: screenWidth,

                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      height: 70,
                                      width: screenWidth/4,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                "${userScore.pos}${
                                                    userScore.pos.toString()[userScore.pos.toString().length - 1] == "1"
                                                        ? "st"
                                                    : userScore.pos.toString()[userScore.pos.toString().length - 1] == "2"
                                                        ? "nd"
                                                    : userScore.pos.toString()[userScore.pos.toString().length - 1] == "3"
                                                        ? "rd"
                                                    : "th"
                                                }",
                                                style: Theme.of(context).textTheme.bodyMedium
                                            ),
                                          ]
                                      )
                                  ),
                                  SizedBox(
                                      height: 70,
                                      width: screenWidth/4,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                image: DecorationImage(image: AssetImage("images/${userScore.image}")),
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  SizedBox(
                                      height: 70,
                                      width: screenWidth/4,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                userScore.username,
                                                style: Theme.of(context).textTheme.labelLarge
                                            ),
                                          ]
                                      )
                                  ),
                                  SizedBox(
                                      height: 70,
                                      width: screenWidth/4,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                userScore.score.toString(),
                                                style: Theme.of(context).textTheme.labelLarge
                                            ),
                                          ]
                                      )
                                  ),
                                ]
                            ),
                          ),
                        ).toList(),
                    ),
                  ),
                ],
              ),
            ]
          ),
        )
      )
    );
  }
}