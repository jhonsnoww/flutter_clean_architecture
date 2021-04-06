import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_random_number_triviar.dart';
import 'package:demo_clean_architecture/features/number_trivia/presentations/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter inputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: inputConverter);
  });

  test('initialState should be empty!', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('getTriviaForConreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test numberTrivia');

    test(
        'should call the InputConverter to validate and convert the string to UnsignedInteger',
        () async {
      when(inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(inputConverter.stringToUnsignedInteger(tNumberString));
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async*{
      when(inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Empty(), Error(message: INPUT_FAILURE_MESSAGE)];
      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
