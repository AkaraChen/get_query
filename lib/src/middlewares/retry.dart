import 'dart:async';

import 'package:get_query/src/middlewares/middleware.dart';

class RetryMiddleware extends Middleware {
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
  Future process(Future Function() action, MiddlewareChain chain) async {
    int attempt = 0;
    while (true) {
      try {
        return await chain.next(action);
      } catch (_) {
        if (++attempt >= maxAttempts) {
          rethrow;
        }
        final delayFactor = this.delayFactor ?? _defaultDelayFactor;
        await Future.delayed(delayFactor(attempt));
      }
    }
  }
}
