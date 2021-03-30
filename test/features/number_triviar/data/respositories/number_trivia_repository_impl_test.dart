import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/error/exceptions.dart';
import 'package:demo_clean_architecture/core/error/failures.dart';
import 'package:demo_clean_architecture/core/platform/network_info.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_triva_remote_datasource.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_tirvia_respositoryImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRespositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRespositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('device is online', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test text', number: tNumber);

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online ..', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    test('should return remote data source is successful', () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => tNumberTriviaModel);

      final result = await repository.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should return local data source when call cache data is successful',
        () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => tNumberTriviaModel);

      await repository.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test(
        'should return server failure source when call remote datasource is unsuccessful',
        () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerExecption());

      final result = await repository.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('devic is offline', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test text', number: tNumber);

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return locally cached data when offline', () async {
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      final result = await repository.getConcreteNumberTrivia(tNumber);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });
  });
}
