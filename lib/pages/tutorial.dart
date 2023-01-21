import 'package:flutter/material.dart';
import 'package:viral_gamification_app/pages/pages.dart';

import '../theme/constants.dart';

class TutorialPage extends StatefulWidget {
  final bool auth;
  const TutorialPage({Key? key, required this.auth}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child:
            PageView(
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              controller: controller,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top:40, left: 50, right: 50, bottom: 10),
                        child: const Text(
                          "Welcome to VIRALITY!\n"
                          "In this game you have 2 goals:\n"
                          "Find out the secret disease, and get the research for that disease to 100% completion.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: Image(
                          image: AssetImage("images/tutorial1.png")
                        ),
                      )
                    ]
                  )
                ),
                Center(
                    child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top:40, left: 50, right: 50, bottom: 10),
                            child: const Text(
                              "You will complete puzzles to:\n"
                              "Learn hints about the secret disease, and earn research points.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Expanded(
                            child: Image(
                              image: AssetImage("images/tutorial2.png")
                            ),
                          )
                        ]
                    )
                ),
                Center(
                    child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top:40, left: 50, right: 50, bottom: 10),
                            child: const Text(
                              "To help figure out what the secret disease is, you can:\n"
                              "Collaborate with all other players in the forum by exchanging hints and other information, and search for information in the glossary.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Expanded(
                            child: Image(
                              image: AssetImage("images/tutorial3.png")
                            ),
                          )
                        ]
                    )
                ),
                Center(
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      child: const Text(
                        "Try to stay healthy! When you come into contact with other players you may become infected. Although being infected does have its perks...",
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: currentPage == 0 ? accentBlue : accentLightGrey,
                      shape: BoxShape.circle
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: currentPage == 1 ? accentBlue : accentLightGrey,
                      shape: BoxShape.circle
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: currentPage == 2 ? accentBlue : accentLightGrey,
                      shape: BoxShape.circle
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: currentPage == 3 ? accentBlue : accentLightGrey,
                      shape: BoxShape.circle
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.resolveWith((states) => const Size(200, 10)),
                backgroundColor: MaterialStateProperty.resolveWith((states) => accentBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )
                ),
              ),
              onPressed: () {
                currentPage == 3
                  ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => widget.auth ? const HomePage() : const LoginRegisterPage(),
                    ),
                  )
                  : controller.animateToPage(currentPage + 1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                currentPage == 3 ? "Begin..." : "Next",
                style: Theme.of(context).textTheme.titleSmall
              )
            ),
          ),
        ],
      )
    );
  }
}