import 'dart:convert';

import 'package:demo_clean_architecture/core/error/exceptions.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_triva_remote_datasource.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response("Something was wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on 
        a URL with number being the endpoing with application/json header''',
        () async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia Model when response code is 200',
        () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw SERVEREXCEPTION when the response code is 404 or Other',
        () {
      setUpMockHttpClientFailure();
      final call = dataSource.getConcreteNumberTrivia;
      expect(call(tNumber), throwsA(isA<ServerExecption>()));
    });
  });

/////////////////////////////////Get RandomNumberTrivia////////////////////////////////////////////

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on 
        a URL with number being the endpoing with application/json header''',
        () async {
      setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia Model when response code is 200',
        () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw SERVEREXCEPTION when the response code is 404 or Other',
        () {
      setUpMockHttpClientFailure();
      final call = dataSource.getRandomNumberTrivia;
      expect(call(), throwsA(isA<ServerExecption>()));
    });
  });
}
