import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viral_gamification_app/providers/user_provider.dart';
import 'package:viral_gamification_app/theme/constants.dart';
import '../api/UserAPI.dart';
import 'pages.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    _tryLoadUser();
  }

  void _tryLoadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString("loginToken");
    if (key != null) {
      AuthReturnState authState = await UserAPI.authenticate(key);
      if (authState == AuthReturnState.DELETE_USER) {
        await prefs.remove("loginToken");
        await _gotoLoginRegister();
        return;
      }
      if (authState == AuthReturnState.AUTHENICATION_FAILED) {
        throw Exception("AUTHENICATION FAILED");
      } else {
        if (!mounted) return; // This is apparently necessary to avoid difficult to diagnose crashes in regards to using context with await
        await context.read<User>().setupInfectionState();
        dynamic userStats = await UserAPI.getUser();
        if (!mounted) return; // This is apparently necessary to avoid difficult to diagnose crashes in regards to using context with await
        context.read<User>().setupUserState(userStats);
        if (!mounted) return;
        context.read<User>().addQuizList(await UserAPI.fetchUserQuizzes());
        if (!mounted) return;
        context.read<User>().addCrosswordList(await UserAPI.fetchUserCrosswords());
        await _gotoHome();
      }
    } else {
      await _gotoLoginRegister();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _gotoLoginRegister() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const TutorialPage(auth: false),
      ),
    );
  }

  _gotoHome() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                margin: const EdgeInsets.all(75),
                child: Text(
                  "VIRALITY",
                  style: textThemeDefault.titleLarge,
                ),
              ),
            ),
            const Flexible(
              fit: FlexFit.tight,
              child: Image(image: AssetImage("images/spore_purple.png")),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container( 
                margin: const EdgeInsets.all(75),
                child: const AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    color: accentPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}