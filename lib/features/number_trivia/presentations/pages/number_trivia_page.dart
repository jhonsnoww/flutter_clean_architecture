import 'package:demo_clean_architecture/features/number_trivia/presentations/bloc/number_trivia_bloc.dart';
import 'package:demo_clean_architecture/features/number_trivia/presentations/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Number Trivia"),
        ),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (c, state) {
                
                  if (state is Empty) {
                    return MessageDisplay(message: "Start Searching!");
                  } else if (state is Loading) {
                    return LoadingDisplay();
                  } else if (state is Loaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else
                    return MessageDisplay(message: "SomeThing was Wrong");
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {
                inputString = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Input a number', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    searchConcreteNumber(context);
                  },
                  child: Text("Search"),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    searchRandomNumber(context);
                  },
                  child: Text("Get Random Trivia"),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void searchConcreteNumber(context) {
    // sl.get<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(inputString));
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void searchRandomNumber(context) {
     sl.get<NumberTriviaBloc>().add(GetTriviaForConcreteNumber('12'));
   // BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
