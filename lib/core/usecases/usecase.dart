import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_tdd/core/error/failures.dart';

abstract class Usecase<Type,Params> {
  Future<Either<Failure,Type>> call({Params params});
}

class NoParams extends Equatable {}
