import 'package:retry/retry.dart';

class RetryConfig {
  final Duration delayFactor;
  final double randomizationFactor;
  final Duration maxDelay;
  final int maxAttempts;
  final Future<bool> Function(Exception)? retryIf;
  final Future<dynamic> Function(Exception)? onRetry;

  const RetryConfig({
    this.delayFactor = const Duration(milliseconds: 200),
    this.randomizationFactor = 0.25,
    this.maxDelay = const Duration(seconds: 30),
    this.maxAttempts = 8,
    this.retryIf,
    this.onRetry,
  });

  Future<T> createRetry<T>(Future<T> Function() fn) async {
    final options = RetryOptions(
      delayFactor: delayFactor,
      randomizationFactor: randomizationFactor,
      maxDelay: maxDelay,
      maxAttempts: maxAttempts,
    );
    return options.retry(
      fn,
      retryIf: retryIf,
      onRetry: onRetry,
    );
  }
}
