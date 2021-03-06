import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}