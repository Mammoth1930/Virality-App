import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../theme/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, accentBlue],
                  stops: [0.6, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
              ),
              child: Column(
                children: [
                  // Profile picture
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage("images/${context.watch<User>().pfp}"))
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                          context.watch<User>().username,
                          style: Theme.of(context).textTheme.titleLarge
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: accentDarkGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: accentGreen,
                                  shape: BoxShape.circle
                              ),
                            ),
                            Text(
                                "Online",
                                style: Theme.of(context).textTheme.bodySmall
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: accentDarkGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                // Toggle text colour depending on state
                                // Red for infected, green for healthy and blue for
                                // immune
                                color: context.watch<User>().state == UserState.infected?
                                accentRed : context.watch<User>().state == UserState.healthy?
                                accentGreen : accentBlue,
                                shape: BoxShape.circle
                              ),
                            ),
                            Text(
                              context.watch<User>().getStateAsString(),
                              style: Theme.of(context).textTheme.bodySmall
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Text(
              "STATISTICS",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: screenWidth/3,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.black, accentGreen],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.watch<User>().puzzles.toString()
                      ),
                      Text(
                        "Puzzles completed",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ),
                Container(
                  width: screenWidth/3,
                  height: 120,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, accentBlue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          context.watch<User>().rounds.toString()
                      ),
                      Text(
                        "Successful rounds",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ),
                Container(
                  width: screenWidth/3,
                  height: 120,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, accentPurple],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          context.watch<User>().totalInfections.toString()
                      ),
                      Text(
                        "Times infected",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}