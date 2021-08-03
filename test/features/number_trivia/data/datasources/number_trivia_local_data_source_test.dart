import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/implementations/number_trivia_local_datasource_impl.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDataConnection extends Mock implements DataConnectionChecker {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      mockSharedPreferences,
    );
  });

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonDecode(
          fixture('trivia_cached.json'),
        ),
      );

      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(fixture(
            'trivia_cached.json',
          ));
          // act
          final result = await dataSource.getNumberTrivia();
          // assert
          verify(mockSharedPreferences.getString('cached_data'));
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw cache exception when there is no data in cache',
        () async {
          bool gotIt = false;
          //arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          //act
          try {
            await dataSource.getNumberTrivia();
          } on CacheException {
            gotIt = true;
          }
          //assert
          expect(gotIt, true);
        },
      );
    },
  );

  group(
    'cache number trivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel(
        text: 'Test Text',
        number: 1,
      );

      test('should cache number trivia model locally', () async {
        //arrange
        when(mockSharedPreferences.setString(
          CACHED_DATA,
          tNumberTriviaModel.toJson().toString(),
        )).thenAnswer(
          (_) async => true,
        );
        //act
        await dataSource.cacheNumberTrivia(tNumberTriviaModel);
        //assert
        verify(mockSharedPreferences.setString(
          CACHED_DATA,
          tNumberTriviaModel.toJson().toString(),
        ));
      });
    },
  );
}
