import 'dart:async';

import 'package:get_query/src/middlewares/retry.dart';

class RetryConfig {
  final int maxAttempts;
  final Duration Function(int attempt)? delayFactor;
  final FutureOr<bool> Function(Exception)? retryIf;
  final FutureOr<void> Function(Exception)? onRetry;

  const RetryConfig({
    this.delayFactor,
    this.maxAttempts = 3,
    this.retryIf,
    this.onRetry,
  });

  RetryMiddleware<T> createRetryMiddleware<T>() {
    return RetryMiddleware(
      delayFactor: delayFactor,
      maxAttempts: maxAttempts,
      retryIf: retryIf,
      onRetry: onRetry,
    );
  }
}
