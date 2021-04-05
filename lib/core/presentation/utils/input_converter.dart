import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/failures.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str) {
    try {
      final i = int.parse(str);

      if (i < 0) throw FormatException();
      return Right(i);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures {
  @override
  List<Object> get props => [];
}
