import 'package:equatable/equatable.dart';

class TestA extends Equatable {
  final String name;
  final String email;

  const TestA(this.name, this.email);

  @override
  List<Object> get props => [name, email];
}

main() {
  final testA = TestA("name", "email");
  final testB = TestA("name", "email");

  print(testA == testB);
}
