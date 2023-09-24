// ignore_for_file: empty_catches

import 'package:get_query/get_query.dart';
import 'package:test/test.dart';

import '../get_query_test.dart';

void main() {
  test('should be able to retry', () async {
    var count = 0;
    final controller = ErrorController(
      options: QueryControllerOptions(
        retry: RetryConfig(
          maxAttempts: 3,
          onRetry: (e) async {
            count++;
          },
        ),
      ),
    );
    try {
      await controller.fetch();
    } catch (e) {}
    expect(count, 3);
  });

  test('should not retry by default in mutation', () {
    var count = 0;
    final controller = ErrorMutation(mutationOptions: MutationControllerOptions(
      retry: RetryConfig(
        onRetry: (e) async {
          count++;
        },
      ),
    ));
    try {
      controller.mutate(null);
    } catch (e) {}
    expect(count, 0);
  });
}
