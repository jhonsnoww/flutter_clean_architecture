import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/usecases/usecase.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_trivia_respository.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_ramdom_number_triviar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviarRespository extends Mock
    implements NumberTriviaReqpository {}

void main() {
  GetRamdomNumberTrivia usecase;
  MockNumberTriviarRespository mockNumberTriviarRespository;

  setUp(() {
    mockNumberTriviarRespository = MockNumberTriviarRespository();
    usecase = GetRamdomNumberTrivia(mockNumberTriviarRespository);
  });

  final tNumberTriviar = NumberTrivia(number: 1, text: 'test');
  test("Should get triviar from respository!!", () async {
    when(mockNumberTriviarRespository.getRamdomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(tNumberTriviar));

    final result = await usecase(NoParams());

    expect(result, Right(tNumberTriviar));
    verify(mockNumberTriviarRespository.getRamdomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviarRespository);
  });
}
