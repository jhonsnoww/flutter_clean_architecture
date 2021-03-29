import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NumberTriviar extends Equatable {
  final String text;
  final int number;

  NumberTriviar({@required this.number, @required this.text});

  @override
  List<Object> get props => [text, number];
}
