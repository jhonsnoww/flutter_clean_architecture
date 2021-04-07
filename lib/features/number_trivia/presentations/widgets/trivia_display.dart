import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;

  const TriviaDisplay({Key key, @required this.trivia}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          trivia.number.toString(),
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                trivia.text,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
