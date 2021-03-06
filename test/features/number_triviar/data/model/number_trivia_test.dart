import 'dart:convert';

import 'package:demo_clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test("should be a subclass of NumberTrivia entity", () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test("should return a valid model when the JSON number is an double",
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

// act
      final result = NumberTriviaModel.fromJson(jsonMap);

// assert
      expect(result, tNumberTriviaModel);
    });

    test("should return a valid model when the JSON number is an integer",
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

// act
      final result = NumberTriviaModel.fromJson(jsonMap);

// assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test("should return JSON map containing the proper data", () async {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {'text': 'Test text', 'number': 1};
      expect(result, expectedMap);
    });
  });
}
