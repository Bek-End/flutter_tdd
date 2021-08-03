part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTriviaConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  GetTriviaConcreteNumber({@required this.numberString});
}

class NumberTriviaInitialEvent extends NumberTriviaEvent {}

class GetTriviaRandomNumber extends NumberTriviaEvent {}
