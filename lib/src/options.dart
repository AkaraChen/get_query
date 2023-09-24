import 'package:get_query/get_query.dart';

class QueryControllerOptions {
  final RetryConfig retry;
  final bool debugMode;
  final QueryClientOptions? queryClient;

  const QueryControllerOptions({
    this.retry = const RetryConfig(maxAttempts: 0),
    this.debugMode = false,
    this.queryClient,
  });
}
