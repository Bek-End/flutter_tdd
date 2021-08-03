import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, int> {

  final NumberTriviaRepository triviaRepository;

  GetConcreteNumberTrivia({@required this.triviaRepository});

  @override
  Future<Either<Failure, NumberTrivia>> call({int params}) async {
    return await triviaRepository.getConcreteNumberTrivia(
      params,
    );
  }
}

