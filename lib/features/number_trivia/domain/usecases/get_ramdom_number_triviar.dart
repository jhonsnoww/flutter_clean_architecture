import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../respositories/number_trivia_respository.dart';

class GetRamdomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaReqpository reqpository;

  GetRamdomNumberTrivia(this.reqpository);

  @override
  Future<Either<Failures, NumberTrivia>> call(NoParams params) async {
    return await reqpository.getRamdomNumberTrivia();
  }
}

