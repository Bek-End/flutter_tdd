import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );
  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is a double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia_double.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should convert model into json',
        () async {
          //arrange
          final Map<String, dynamic> jsonMap = jsonDecode(
            fixture('trivia.json'),
          );
          //act
          final res = NumberTriviaModel.fromJson(jsonMap);
          final Map<String, dynamic> json = res.toJson();
          final Map<String, dynamic> testJson = {
            jsonMap.keys.elementAt(0): jsonMap[jsonMap.keys.elementAt(0)],
            jsonMap.keys.elementAt(1): jsonMap[jsonMap.keys.elementAt(1)]
          };
          //assert
          expect(testJson, json);
        },
      );
    },
  );
}
