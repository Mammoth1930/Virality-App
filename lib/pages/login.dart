import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viral_gamification_app/pages/pfpselect.dart';
import 'package:viral_gamification_app/theme/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../api/UserAPI.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  bool nameTaken = false;

  @override
  void initState() {
    super.initState();
  }

  _gotoAuth(String username) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PFPSelectionPage(username: username),
      ),
    );
  }

  void _registerNameAndAuth(String name) async {
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final String? loginToken = await UserAPI.createUser(name, deviceInfo.hashCode.toString());
    if (loginToken == null) {
      setState(() {
        nameTaken = true;
      });
    } else {
      await prefs.setString("loginToken", loginToken);
      await _gotoAuth(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 110, right: 110, top: 50),
                child: const Image(
                    image: AssetImage("images/spore_purple.png")),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(bottom: 10),
                child: Text("CREATE USERNAME", style: textThemeDefault.titleMedium),
              ),
              TextField(
                onChanged: (text)=>setState(() {
                  nameTaken = false;
                }),
                onSubmitted: (text) { _registerNameAndAuth(text); },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Username",
                  errorText: nameTaken ? "Username taken" : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}