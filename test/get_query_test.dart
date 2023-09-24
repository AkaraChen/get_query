// ignore_for_file: invalid_use_of_protected_member, empty_catches, argument_type_not_assignable_to_error_handler

import 'package:get_query/get_query.dart';
import 'package:get_query/src/middlewares/retry.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';

final Logger logger = Logger();

class SimpleController extends QueryController<String, void, String> {
  SimpleController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    return 'data';
  }
}

class ErrorController extends QueryController<String, void, String> {
  ErrorController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    throw Exception('error');
  }
}

class ErrorMutation extends MutationController<String, void, String> {
  ErrorMutation({super.context = '', super.mutationOptions});

  @override
  Future<String> callMutate(String context, void body) async {
    throw Exception('error');
  }
}

void main() {
  test('should be able to fetch data', () async {
    final controller = SimpleController();
    await controller.fetch();
    expect(controller.data, isA<String>());
  });

  test('should be able to have error', () async {
    final controller = ErrorController();
    try {
      await controller.fetch();
    } catch (e) {}
    expect(controller.error, isNot(Null));
  });

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
