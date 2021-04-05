import 'package:dartz/dartz.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
        'should return an integer when the string represents to un unsigned integer',
        () {
      final String str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Right(123));
    });
  });

  test('should return Failure when the String is not an integer', () {
    final String str = 'abcd';
    final result = inputConverter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return Failure when the String is an negative integer', () {
    final String str = '-123';
    final result = inputConverter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });
}
