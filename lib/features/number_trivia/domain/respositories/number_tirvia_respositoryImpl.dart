import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/exceptions.dart';
import 'package:demo_clean_architecture/core/platform/network_info.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_triva_remote_datasource.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import 'number_trivia_respository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRespositoryImpl implements NumberTriviaReqpository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRespositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() async {
      return await remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  Future<Either<Failures, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getRandomOrConcrete) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getRandomOrConcrete();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExecption {
        return Left(ServerFailure());
      }
    } else {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    }
  }
}
