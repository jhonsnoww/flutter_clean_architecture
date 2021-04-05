import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_random_number_triviar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required this.inputConverter})
      : assert(GetConcreteNumberTrivia != null),
        assert(GetRandomNumberTrivia != null),
        concreteNumberTrivia = concrete,
        randomNumberTrivia = random,
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {}
}
