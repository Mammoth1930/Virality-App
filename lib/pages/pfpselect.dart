import 'package:flutter/material.dart';

import '../api/UserAPI.dart';
import '../theme/constants.dart';
import 'authenticating.dart';

class PFPSelectionPage extends StatefulWidget {
  final String username;
  const PFPSelectionPage({Key? key, required this.username}) : super(key: key);

  @override
  State<PFPSelectionPage> createState() => _PFPSelectionPageState();
}

class _PFPSelectionPageState extends State<PFPSelectionPage> {

  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Choose your profile picture",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: ButtonTheme(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: MaterialButton(
                      onPressed: () { setState(() {
                        selected = 1;
                      }); },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: selected == 1 ? const Border(
                              bottom: BorderSide(color: accentBlue, width: 10)
                          ) : const Border(),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Image(
                              image: AssetImage("images/pfp1.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ButtonTheme(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: MaterialButton(
                      onPressed: () { setState(() {
                        selected = 2;
                      }); },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: selected == 2 ? const Border(
                              bottom: BorderSide(color: accentBlue, width: 10)
                          ) : const Border(),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Image(
                              image: AssetImage("images/pfp2.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ButtonTheme(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: MaterialButton(
                      onPressed: () { setState(() {
                        selected = 3;
                      }); },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: selected == 3 ? const Border(
                              bottom: BorderSide(color: accentBlue, width: 10)
                          ) : const Border(),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Image(
                              image: AssetImage("images/pfp3.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ButtonTheme(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: MaterialButton(
                      onPressed: () { setState(() {
                        selected = 4;
                      }); },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: selected == 4 ? const Border(
                              bottom: BorderSide(color: accentBlue, width: 10)
                          ) : const Border(),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Image(
                              image: AssetImage("images/pfp4.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ButtonTheme(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: MaterialButton(
                      onPressed: () { setState(() {
                        selected = 5;
                      }); },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: selected == 5 ? const Border(
                            bottom: BorderSide(color: accentBlue, width: 10)
                          ) : const Border(),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: const Image(
                            image: AssetImage("images/pfp5.png"),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => accentBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  ),
                ),
                onPressed: () {
                  UserAPI.setPFP(widget.username, "pfp$selected.png");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}