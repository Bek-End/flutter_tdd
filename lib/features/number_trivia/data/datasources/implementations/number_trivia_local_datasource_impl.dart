import 'dart:convert';
import 'package:flutter_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_datasource_local.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_DATA = 'cached_data';

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    String mapStringToSave = triviaToCache.toJson().toString();
    await sharedPreferences.setString(CACHED_DATA, mapStringToSave);
  }

  @override
  Future<NumberTriviaModel> getNumberTrivia() async {
    try {
      var value = sharedPreferences.getString(CACHED_DATA);
      if (value != null) {
        print(
          jsonDecode(value) as Map<String, dynamic>,
        );
        NumberTriviaModel numberTriviaModel = NumberTriviaModel.fromJson(
          jsonDecode(value) as Map<String, dynamic>,
        );
        return numberTriviaModel;
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
