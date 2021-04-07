import 'package:equatable/equatable.dart';

abstract class ComeOn {}

class TestA extends Equatable implements ComeOn {
  final String name;
  final String email;

  const TestA(this.name, this.email);

  @override
  List<Object> get props => [name, email];
}

class TestB extends Equatable implements ComeOn {
  @override
  List<Object> get props => [];
}

main() {
  ComeOn testA = TestA("name", "email");
  ComeOn testAA = TestA("name", "emaill");
  final testB = TestB();

  print(testA is TestA);
}
