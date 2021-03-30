import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../respositories/number_trivia_respository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaReqpository reqpository;

  GetConcreteNumberTrivia(this.reqpository);

  @override
  Future<Either<Failures, NumberTrivia>> call(Params params) async {
    return await reqpository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params(this.number);

  @override
  List<Object> get props => [number];
}
