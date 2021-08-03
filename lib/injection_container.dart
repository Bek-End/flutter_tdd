import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_datasource_local.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'features/number_trivia/domain/usecases/get_random_number_usecase.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/data/datasources/number_trivia_datasource_remote.dart';
import 'features/number_trivia/data/datasources/implementations/number_trivia_remote_data_source_impl.dart';
import 'features/number_trivia/data/datasources/implementations/number_trivia_local_datasource_impl.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/implementations/number_trivia_local_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - Number Trivia
//Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );
  //Usecases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      triviaRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(
      triviaRepository: sl(),
    ),
  );
  //Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  //DataSources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sl(),
    ),
  );
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl(),
    ),
  );
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
