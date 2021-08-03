part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Error extends NumberTriviaState {
  final String message;
  Error({@required this.message});
}

class ShowDataState extends NumberTriviaState {
  final String number;
  final String text;
  ShowDataState({
    @required this.number,
    @required this.text,
  });
}
