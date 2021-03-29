import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_triviar_respository.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviarRespository extends Mock
    implements NumberTriviarReqpository {}

void main() {
  GetConcreteNumberTriviar usecase;
  MockNumberTriviarRespository mockNumberTriviarRespository;

  setUp(() {});
}
