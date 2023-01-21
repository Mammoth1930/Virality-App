import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:viral_gamification_app/pages/authenticating.dart';
import 'package:viral_gamification_app/providers/quiz_timer.dart';
import 'package:viral_gamification_app/providers/recharge_timer.dart';
import 'providers/user_provider.dart';
import 'providers/countdown_provider.dart';
import 'theme/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
        ChangeNotifierProvider(create: (_) => Clock()),
        ChangeNotifierProvider(create: (_) => QuizTimer()),
        ChangeNotifierProvider(create: (_) => RechargeTimer())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? whatsHome;

  @override
  initState() {
    super.initState();
    _askPermissions();

  }

  void _askPermissions() async {
    await Nearby().askLocationPermission();
    Nearby().askBluetoothPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virality',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: backgroundBlack,
          textTheme: textThemeDefault,
          fontFamily: "ShareTech"
      ),
      home:  const AuthPage(),
    );
  }
}