import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_datasource_remote.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final Dio dio;
  NumberTriviaRemoteDataSourceImpl(this.dio);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    try {
      return _getNumberTrivia('http://numbersapi.com/$number?json');
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    try {
      return _getNumberTrivia('http://numbersapi.com/random/trivia?json');
    } catch (e) {
      throw e;
    }
  }

  Future<NumberTriviaModel> _getNumberTrivia(String path) async {
    try {
      var response = await dio.get(
        path,
      );
      return NumberTriviaModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }
}
