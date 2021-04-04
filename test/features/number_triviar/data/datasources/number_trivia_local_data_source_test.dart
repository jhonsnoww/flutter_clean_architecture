import 'dart:convert';

import 'package:demo_clean_architecture/core/error/exceptions.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreference mockSharedPreference;

  setUp(() {
    mockSharedPreference = MockSharedPreference();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreference);
  });

  group('getLastNumberTrivia', () {
    final tNumberTrivaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('cached_trivia.json')));
    test(
        'should return NumberTrivia From sharedpreference when there is one in cache data',
        () async {
      when(mockSharedPreference.getString(any))
          .thenReturn(fixture('cached_trivia.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreference.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTrivaModel));
    });

    test(
        'should throw cacheExpection when there is no one cache in Sharepreferenced',
        () async {
      when(mockSharedPreference.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;
      expect(call, throwsA(isA<CacheExecption>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTrivia = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferenced to cache the data ', () {
      dataSource.cacheNumberTrivia(tNumberTrivia);

      final expectedJsonstring = json.encode(tNumberTrivia.toJson());
      verify(mockSharedPreference.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonstring));
    });
  });
}
