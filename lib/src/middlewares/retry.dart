import 'dart:async';

import 'package:get_query/src/middlewares/middleware.dart';

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

class RetryMiddleware<T> extends Middleware<T> {
  final int maxAttempts;
  final Duration Function(int attempt)? delayFactor;
  final FutureOr<bool> Function(Exception)? retryIf;
  final FutureOr<void> Function(Exception)? onRetry;

  static Duration _defaultDelayFactor(int attempt) {
    return Duration(milliseconds: 500 * attempt);
  }

  RetryMiddleware({
    this.maxAttempts = 3,
    this.delayFactor = _defaultDelayFactor,
    this.retryIf,
    this.onRetry,
  });

  @override
  Future<T> process(
      Future<T> Function() action, MiddlewareChain<T> chain) async {
    int attempt = 0;
    while (true) {
      try {
        return await chain.next(action);
      } on Exception catch (e) {
        if (onRetry != null) {
          await onRetry!(e);
        }
        if (retryIf != null && !(await retryIf!(e))) {
          rethrow;
        }
        if (++attempt >= maxAttempts) {
          rethrow;
        }
        final delayFactor = this.delayFactor ?? _defaultDelayFactor;
        await Future.delayed(delayFactor(attempt));
      }
    }
  }
}
