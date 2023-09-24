import 'package:get_query/src/middlewares/retry.dart';

class QueryControllerOptions {
  final RetryConfig retry;
  final bool debugMode;

  const QueryControllerOptions({
    this.retry = const RetryConfig(maxAttempts: 0),
    this.debugMode = false,
  });
}
