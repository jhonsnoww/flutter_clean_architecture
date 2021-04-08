import 'dart:convert';

import 'package:demo_clean_architecture/core/error/exceptions.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getTriviaFromUrl("http://numbersapi.com/random");

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {
    print("Url ::: $url");
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    print('Response $response');
    if (response.statusCode == 200) {
      print("Success");
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      print("Failed");
      throw ServerExecption();
    }
  }
}
