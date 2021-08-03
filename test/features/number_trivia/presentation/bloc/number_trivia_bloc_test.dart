import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_tdd/core/util/input_converter.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_usecase.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc numberTriviaBloc;
  setUp(
    () {
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockInputConverter = MockInputConverter();
      numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      );
    },
  );
  test('initial state should be empty', () {
    expect(numberTriviaBloc.state, Empty());
  });
  group(
    'get trivia for concrete number',
    () {
      // The event takes in a String
      final tNumberString = '1';
      final tText = 'test trivia';
      // This is the successful output of the InputConverter
      final tNumberParsed = int.parse(tNumberString);
      // NumberTrivia instance is needed too, of course
      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          //arrange
          when(
            mockInputConverter.stringToUnsignedInteger(tNumberString),
          ).thenReturn(Left(InvalidInputFailure()));
          //act
          numberTriviaBloc.add(
            GetTriviaConcreteNumber(numberString: tNumberString),
          );
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          //assert
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );
      test(
        'should emit [Error] when there is invalid input failure',
        () async {
          //arrange
          when(
            mockInputConverter.stringToUnsignedInteger(any),
          ).thenReturn(
            Left(InvalidInputFailure()),
          );
          //act
          final expected = [
            Loading(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          numberTriviaBloc.add(
            GetTriviaConcreteNumber(numberString: tNumberString),
          );
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          //assert
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );
      test(
        'should emit show data state when there are no failures',
        () async {
          //arrange
          when(
            mockInputConverter.stringToUnsignedInteger(tNumberString),
          ).thenReturn(
            Right(tNumberParsed),
          );
          when(mockGetConcreteNumberTrivia(params: tNumberParsed)).thenAnswer(
            (_) async => Right(
              NumberTrivia(
                number: tNumberParsed,
                text: tText,
              ),
            ),
          );
          //act
          final expected = [
            Loading(),
            ShowDataState(number: tNumberString, text: tText),
          ];
          numberTriviaBloc.add(
            GetTriviaConcreteNumber(
              numberString: tNumberString,
            ),
          );
          //assert later
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
        },
      );
      test(
        'should emit [Error] state when there is a ServerFailures',
        () async {
          //arrange
          when(
            mockInputConverter.stringToUnsignedInteger(tNumberString),
          ).thenReturn(
            Right(tNumberParsed),
          );
          when(mockGetConcreteNumberTrivia(params: tNumberParsed)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          //act
          numberTriviaBloc.add(
            GetTriviaConcreteNumber(
              numberString: tNumberString,
            ),
          );
          //assert later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
        },
      );
      test(
        'should emit [Error] state when there is a CacheFailure',
        () async {
          //arrange
          when(
            mockInputConverter.stringToUnsignedInteger(tNumberString),
          ).thenReturn(
            Right(tNumberParsed),
          );
          when(mockGetConcreteNumberTrivia(params: tNumberParsed)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          //act
          numberTriviaBloc.add(
            GetTriviaConcreteNumber(
              numberString: tNumberString,
            ),
          );
          //assert later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
          await untilCalled(mockGetConcreteNumberTrivia(params: tNumberParsed));
          verify(mockGetConcreteNumberTrivia(params: tNumberParsed));
        },
      );
    },
  );
  group(
    'get trivia for random number',
    () {
      // The event takes in a String
      final tNumberString = '1';
      final tText = 'test trivia';
      // This is the successful output of the InputConverter
      final tNumberParsed = int.parse(tNumberString);
      // NumberTrivia instance is needed too, of course
      test(
        'should emit show data state when there are no failures',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(params: NoParams())).thenAnswer(
            (_) async => Right(
              NumberTrivia(
                number: tNumberParsed,
                text: tText,
              ),
            ),
          );
          //act
          numberTriviaBloc.add(
            GetTriviaRandomNumber(),
          );
          //assert later
          final expected = [
            Loading(),
            ShowDataState(number: tNumberString, text: tText),
          ];
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
        },
      );
      test(
        'should emit [Error] state when there is a ServerFailures',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(params: NoParams())).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          //act
          numberTriviaBloc.add(
            GetTriviaRandomNumber(),
          );
          //assert later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
        },
      );
      test(
        'should emit [Error] state when there is a CacheFailure',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(params: NoParams())).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          //act
          numberTriviaBloc.add(
            GetTriviaRandomNumber(),
          );
          //assert later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          await expectLater(
            numberTriviaBloc,
            emitsInOrder(expected),
          );
          await untilCalled(mockGetRandomNumberTrivia(params: NoParams()));
          verify(mockGetRandomNumberTrivia(params: NoParams()));
        },
      );
    },
  );
}
