import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_trivia_respository.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviarRespository extends Mock
    implements NumberTriviaReqpository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviarRespository mockNumberTriviarRespository;

  setUp(() {
    mockNumberTriviarRespository = MockNumberTriviarRespository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviarRespository);
  });

  final tNumber = 1;
  final tNumberTriviar = NumberTrivia(number: 1, text: 'test');
  test("Should get triviar for the number from respository!!", () async {
    when(mockNumberTriviarRespository.getConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTriviar));

    final result = await usecase(Params(tNumber));

    expect(result, Right(tNumberTriviar));
    verify(mockNumberTriviarRespository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviarRespository);
  });
}
