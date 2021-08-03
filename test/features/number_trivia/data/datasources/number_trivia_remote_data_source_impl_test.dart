import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/implementations/number_trivia_remote_data_source_impl.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  MockDio mockDio;
  NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  setUp(() {
    mockDio = MockDio();
    remoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(mockDio);
  });
  final tNum = 42;
  final tConcreteUrl = 'http://numbersapi.com/$tNum';
  final tRandUrl = 'http://numbersapi.com/random/trivia?json';
  final tNumberTrivia = NumberTriviaModel.fromJson(jsonDecode(
    fixture('trivia.json'),
  ));
  group(
    'get concrete number trivia',
    () {
      test(
        'should return number trivia when successfully connected',
        () async {
          //arrange
          when(mockDio.get(tConcreteUrl)).thenAnswer(
            (_) async => Response(
              data: fixture('trivia.json'),
            ),
          );
          //act
          final res = await remoteDataSourceImpl.getConcreteNumberTrivia(tNum);
          //assert
          expect(res, tNumberTrivia);
          verify(mockDio.get(tConcreteUrl));
        },
      );
      test(
        'should throw server exception when there is unsuccessful connection',
        () async {
          //arrange
          bool hasException = false;
          when(mockDio.get(tConcreteUrl)).thenAnswer(
            (_) async => Response(
              data: null,
              statusCode: 404,
            ),
          );
          //act
          try {
            await remoteDataSourceImpl.getConcreteNumberTrivia(
              tNum,
            );
          } on Exception {
            hasException = true;
          }
          //assert
          expect(hasException, true);
        },
      );
    },
  );
  group(
    'get random number trivia',
    () {
      test(
        'should return number trivia when successfully connected',
        () async {
          //arrange
          when(mockDio.get(tRandUrl)).thenAnswer(
            (_) async => Response(
              data: fixture('trivia.json'),
            ),
          );
          //act
          final res = await remoteDataSourceImpl.getRandomNumberTrivia();
          //assert
          expect(res, tNumberTrivia);
          verify(mockDio.get(tRandUrl));
        },
      );
      test(
        'should throw server exception when there is unsuccessful connection',
        () async {
          //arrange
          bool hasException = false;
          when(mockDio.get(tRandUrl)).thenThrow(ServerException());
          //act
          try {
            await remoteDataSourceImpl.getRandomNumberTrivia();
          } on Exception {
            hasException = true;
          }
          //assert
          expect(hasException, true);
        },
      );
    },
  );
}
