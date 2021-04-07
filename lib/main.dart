import 'package:demo_clean_architecture/features/number_trivia/presentations/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primarySwatch: Colors.green, accentColor: Colors.green.shade600),
      home: NumberTriviaPage(),
    );
  }
}
