import 'package:flutter/material.dart';

class QuizAnswer extends StatelessWidget {
  final String answerText;
  final Color answerColor;
  final VoidCallback answerTapped;

  QuizAnswer({required this.answerText, required this.answerColor, required this.answerTapped});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: answerTapped,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: answerColor,
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(answerText, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}