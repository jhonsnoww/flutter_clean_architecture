import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/failures.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:demo_clean_architecture/core/usecases/usecase.dart';
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

    void setUpMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to UnsignedInteger',
        () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(inputConverter.stringToUnsignedInteger(tNumberString));
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async* {
      when(inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Empty(), Error(message: INPUT_FAILURE_MESSAGE)];
      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
    });

    test('should emit [Loading , Loaded ] when data is gotten successfull', () {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading , Error ] when data is gotten fail', () {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading , Error ] with proper message for error when getting data fail',
        () {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
  ////get Trivia for Random Number//////
  
  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test numberTrivia');

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading , Loaded ] when data is gotten successfull', () {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading , Error ] when data is gotten fail', () {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading , Error ] with proper message for error when getting data fail',
        () {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];

      expectLater(
        bloc,
        emitsInOrder(expected),
      );
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
