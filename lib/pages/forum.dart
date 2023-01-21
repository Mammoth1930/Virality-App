import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/UserAPI.dart';
import '../providers/user_provider.dart';
import '../theme/constants.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<List<String>> messages = [];
  final textController = TextEditingController();
  late WebSocket channel;

  @override
  void initState() {
    createConnection();
    super.initState();
  }

  void createConnection() async {
    channel = await WebSocket.connect("ws://${UserAPI.API_HOST}/api/v0/message/new/sock");
    channel.listen((message) {
      var jr = json.decode(message);
      setState(() {
        messages.add([jr["user"], jr["message"]]);
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    channel.close();
    super.dispose();
  }

  void sendMessage(BuildContext context, TextEditingController controller) async {
    if (textController.text != '') {
      channel.add(jsonEncode({"user": context.read<User>().username, "message": textController.text}));
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlack,
      ),
      body: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: messages.map((message) =>
                  message[0] == context.read<User>().username
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: accentBlue,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message[1]),
                          ],
                        )
                      ),
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: backgroundDarkGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message[0],
                              style: textThemeDefault.bodySmall,
                            ),
                            Text(message[1]),
                          ],
                        )
                      ),
                    )
                ).toList().reversed.toList(),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) => sendMessage(context, textController),
                    onEditingComplete: () {},
                  ),
                ),
                MaterialButton(
                  onPressed: () => sendMessage(context, textController),
                  color: accentBlue,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
    );
  }
}