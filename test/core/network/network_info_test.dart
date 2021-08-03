import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture_tdd/core/network/network_info_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });
  group('is connected', () {
    final tHasConnection = Future.value(true);
    test('should return true when there is internet connection', () async {
      //arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnection);
      //act
      final res = networkInfoImpl.isConnected;
      //assert
      expect(res, tHasConnection);
    });
  });
}
