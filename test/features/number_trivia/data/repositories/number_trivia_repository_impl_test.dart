import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd/core/network/network_info.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_datasource_local.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_datasource_remote.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class NumberTriviaRemoteDataSourceMock extends Mock
    implements NumberTriviaRemoteDataSource {}

class NumberTriviaLocalDataSourceMock extends Mock
    implements NumberTriviaLocalDataSource {}

class NetworkInfoMock extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl impl;
  NumberTriviaRemoteDataSourceMock remoteDataSourceMock;
  NumberTriviaLocalDataSourceMock localDataSourceMock;
  NetworkInfoMock infoMock;
  setUp(
    () {
      remoteDataSourceMock = NumberTriviaRemoteDataSourceMock();
      localDataSourceMock = NumberTriviaLocalDataSourceMock();
      infoMock = NetworkInfoMock();
      impl = NumberTriviaRepositoryImpl(
        remoteDataSource: remoteDataSourceMock,
        localDataSource: localDataSourceMock,
        networkInfo: infoMock,
      );
    },
  );
  group(
    'get concrete number trivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(
        number: tNumber,
        text: 'test trivia',
      );
      test(
        'should check if the device is connected to internet',
        () async {
          //arange
          when(infoMock.isConnected).thenAnswer((_) async => true);
          //act
          impl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(infoMock.isConnected);
        },
      );

      group(
        'device online',
        () {
          setUp(
            () {
              when(infoMock.isConnected).thenAnswer((_) async => true);
            },
          );
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getConcreteNumberTrivia(any),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(remoteDataSourceMock.getConcreteNumberTrivia(tNumber));
              expect(
                result,
                equals(
                  Right(
                    tNumberTriviaModel,
                  ),
                ),
              );
            },
          );
          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getConcreteNumberTrivia(any),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(remoteDataSourceMock.getConcreteNumberTrivia(tNumber));
              verify(localDataSourceMock.cacheNumberTrivia(tNumberTriviaModel));
              expect(
                result,
                equals(
                  Right(tNumberTriviaModel),
                ),
              );
            },
          );
          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getConcreteNumberTrivia(any),
              ).thenThrow(ServerException());
              // act
              final result = await impl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(remoteDataSourceMock.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(localDataSourceMock);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
      group(
        'device offline',
        () {
          setUp(
            () {
              when(infoMock.isConnected).thenAnswer((_) async => false);
            },
          );
          test(
            'should return last locally cached data when cached data is present',
            () async {
              // arrange
              when(
                localDataSourceMock.getNumberTrivia(),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(localDataSourceMock.getNumberTrivia());
              verifyZeroInteractions(remoteDataSourceMock);
              expect(
                result,
                equals(
                  Right(
                    tNumberTriviaModel,
                  ),
                ),
              );
            },
          );
          test(
            'should throw cache failure on cache exception when cached data is not present',
            () async {
              // arrange
              when(
                localDataSourceMock.getNumberTrivia(),
              ).thenThrow(CacheException());
              // act
              final result = await impl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(localDataSourceMock.getNumberTrivia());
              verifyZeroInteractions(remoteDataSourceMock);
              expect(
                result,
                equals(
                  Left(
                    CacheFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
  group(
    'get random number trivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(
        number: tNumber,
        text: 'test trivia',
      );
      test(
        'should check if the device is connected to internet',
        () async {
          //arange
          when(infoMock.isConnected).thenAnswer((_) async => true);
          //act
          impl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(infoMock.isConnected);
        },
      );

      group(
        'device online',
        () {
          setUp(
            () {
              when(infoMock.isConnected).thenAnswer((_) async => true);
            },
          );
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getRandomNumberTrivia(),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getRandomNumberTrivia();
              // assert
              verify(remoteDataSourceMock.getRandomNumberTrivia());
              expect(
                result,
                equals(
                  Right(
                    tNumberTriviaModel,
                  ),
                ),
              );
            },
          );
          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getRandomNumberTrivia(),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getRandomNumberTrivia();
              // assert
              verify(remoteDataSourceMock.getRandomNumberTrivia());
              verify(localDataSourceMock.cacheNumberTrivia(tNumberTriviaModel));
              expect(
                result,
                equals(
                  Right(tNumberTriviaModel),
                ),
              );
            },
          );
          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(
                remoteDataSourceMock.getRandomNumberTrivia(),
              ).thenThrow(ServerException());
              // act
              final result = await impl.getRandomNumberTrivia();
              // assert
              verify(remoteDataSourceMock.getRandomNumberTrivia());
              verifyZeroInteractions(localDataSourceMock);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
      group(
        'device offline',
        () {
          setUp(
            () {
              when(infoMock.isConnected).thenAnswer((_) async => false);
            },
          );
          test(
            'should return last locally cached data when cached data is present',
            () async {
              // arrange
              when(
                localDataSourceMock.getNumberTrivia(),
              ).thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await impl.getRandomNumberTrivia();
              // assert
              verify(localDataSourceMock.getNumberTrivia());
              verifyZeroInteractions(remoteDataSourceMock);
              expect(
                result,
                equals(
                  Right(
                    tNumberTriviaModel,
                  ),
                ),
              );
            },
          );
          test(
            'should throw cache failure on cache exception when cached data is not present',
            () async {
              // arrange
              when(
                localDataSourceMock.getNumberTrivia(),
              ).thenThrow(CacheException());
              // act
              final result = await impl.getRandomNumberTrivia();
              // assert
              verify(localDataSourceMock.getNumberTrivia());
              verifyZeroInteractions(remoteDataSourceMock);
              expect(
                result,
                equals(
                  Left(
                    CacheFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
