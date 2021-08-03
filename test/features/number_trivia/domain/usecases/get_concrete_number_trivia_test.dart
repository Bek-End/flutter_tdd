import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(
      triviaRepository: mockNumberTriviaRepository,
    );
  });
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  final tNumber = 1;
  test('should get trivia for the number from repository', () async {
    //arange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
      (_) async => Right(tNumberTrivia),
    );
    //act
    final result = await usecase(params: tNumber);
    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(tNumberTrivia));
    // Verify that the method has been called on the Repository
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
    //assert
  });
}
