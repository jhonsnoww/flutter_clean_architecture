import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/failures.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_triviar.dart';

abstract class NumberTriviarReqpository {
  Future<Either<Failures, NumberTriviar>> getConcreteNumberTriviar(int number);
  Future<Either<Failures, NumberTriviar>> getRamdomNumberTriviar();
}
