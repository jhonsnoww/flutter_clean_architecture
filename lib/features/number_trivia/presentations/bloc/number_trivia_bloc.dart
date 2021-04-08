import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/failures.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:demo_clean_architecture/core/usecases/usecase.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_random_number_triviar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Faild";
const String CACHE_FAILURE_MESSAGE = "Cache Faild";
const String INPUT_FAILURE_MESSAGE =
    "Invalid Input String - the number must be positive number or zero";

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

  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      print("Hello Search!");
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        print("Valid Input Number :: $integer");
        yield Loading();
        final failureOrTrivia = await concreteNumberTrivia(Params(integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
    
      yield Loading();
      final failureOrTrivia = await randomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }


  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failures, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) {
        print("Trivia :: ${trivia.text}");
        return Loaded(trivia: trivia);
      },
    );
  }

  String _mapFailureToMessage(Failures failures) {
    switch (failures.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
        break;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
        break;
      default:
        return 'Unexpected error';
    }
  }
}
