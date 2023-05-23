import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/providers/network_check_provider_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkCheckProvider networkCheckProvider;
  late MockDataChecker dataChecker;

  setUp(() {
    dataChecker = MockDataChecker();
    networkCheckProvider = NetworkCheckProviderImpl(dataChecker);
  });

  group('NetworkCheckProvider', () {
    test('When there is internet should return true', () async {
      // Arrange
      when(() => dataChecker.connectionStatus).thenAnswer(
        (_) async => InternetConnectionStatus.connected,
      );

      // Act
      final result = await networkCheckProvider.isOnline();

      // Assert
      expect(result, isTrue);
    });

    test('When there is no internet should return false', () async {
      // Arrange
      when(() => dataChecker.connectionStatus).thenAnswer(
        (_) async => InternetConnectionStatus.disconnected,
      );

      // Act
      final result = await networkCheckProvider.isOnline();

      // Assert
      expect(result, isFalse);
    });

    test('Should emit true or false according to stream', () {
      // Arrange
      when(() => dataChecker.onStatusChange).thenAnswer(
        (_) => Stream.fromIterable(
          [
            InternetConnectionStatus.connected,
            InternetConnectionStatus.disconnected,
            InternetConnectionStatus.connected,
          ],
        ),
      );

      // Act
      final result = networkCheckProvider.networkState;

      // Assert
      expect(
        result,
        emitsInOrder(
          [
            true,
            false,
            true,
          ],
        ),
      );
    });
  });
}
