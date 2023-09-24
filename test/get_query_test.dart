// ignore_for_file: invalid_use_of_protected_member, empty_catches, argument_type_not_assignable_to_error_handler

import 'package:get_query/get_query.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';

final Logger logger = Logger();

class SimpleController extends QueryController<String, void, String> {
  SimpleController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    await Future.delayed(Duration(seconds: 1));
    return 'data';
  }
}

class ErrorController extends QueryController<String, void, String> {
  ErrorController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    await Future.delayed(Duration.zero);
    throw Exception('error');
  }
}

void main() {
  test('should be able to fetch data', () async {
    final controller = SimpleController();
    await controller.fetch();
    expect(controller.data.value, isA<String>());
  });

  test('should be able to have error', () async {
    final controller = ErrorController(
      context: '',
    );
    try {
      await controller.fetch();
    } catch (e) {}
    expect(controller.error, isNot(Null));
  });

  test('should be able to retry', () async {
    var count = 0;
    final controller = ErrorController(
      context: '',
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
    expect(count, isNot(0));
  });
}
