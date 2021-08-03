import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_tdd/core/util/input_converter.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_usecase.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.inputConverter,
  }) : super(Empty());

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTriviaConcreteNumber:
        yield Loading();
        GetTriviaConcreteNumber concreteNumber = event;
        final number = inputConverter.stringToUnsignedInteger(
          concreteNumber.numberString,
        );
        yield* number.fold(
          (l) async* {
            yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
          },
          (r) async* {
            final numberTrivia = await getConcreteNumberTrivia(params: r);
            yield* numberTrivia.fold(
              (l) async* {
                if (l is ServerFailure) {
                  yield Error(message: SERVER_FAILURE_MESSAGE);
                } else {
                  yield Error(message: CACHE_FAILURE_MESSAGE);
                }
              },
              (r) async* {
                yield ShowDataState(
                  number: r.number.toString(),
                  text: r.text,
                );
              },
            );
          },
        );
        break;
      case GetTriviaRandomNumber:
        yield Loading();
        final number = await getRandomNumberTrivia(params: NoParams());
        yield* number.fold(
          (l) async* {
            if (l is ServerFailure) {
              yield Error(message: SERVER_FAILURE_MESSAGE);
            } else {
              yield Error(message: CACHE_FAILURE_MESSAGE);
            }
          },
          (r) async* {
            yield ShowDataState(
              number: r.number.toString(),
              text: r.text,
            );
          },
        );
        break;
    }
  }
}
