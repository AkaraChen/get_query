import 'dart:async';

import 'package:get_query/get_query.dart';

class MutationControllerOptions extends QueryControllerOptions {
  const MutationControllerOptions({
    retry = const RetryConfig(maxAttempts: 0),
  }) : super(retry: retry);
}

// Use for doing some async task
class MutationController<RequestBody, ResponseData>
    extends QueryController<RequestBody, ResponseData> {
  final MutationControllerOptions mutationOptions;

  final FutureOr<void> Function(ResponseData data)? onMutateSuccess;
  final FutureOr<void> Function(dynamic err)? onMutateError;
  final FutureOr<void> Function()? onMutateComplete;

  MutationController({
    this.mutationOptions = const MutationControllerOptions(),
    required super.call,
    this.onMutateSuccess,
    this.onMutateError,
    this.onMutateComplete,
  });

  bool get isMutating => isFetching;

  @override
  Future<void> fetch(RequestBody body) async {
    throw UnsupportedError('Use mutate() instead');
  }

  Future<void> mutate(RequestBody body) async {
    try {
      final middlewareChain = MiddlewareChain<ResponseData>([
        options.retry.createRetryMiddleware<ResponseData>(),
      ]);

      var futureWithMiddleware = middlewareChain.applyMiddleware(
        () => call(body),
      );

      future.value = futureWithMiddleware;
      final response = await futureWithMiddleware;
      await onMutateSuccess?.call(response);
    } catch (err) {
      await onMutateError?.call(err);
      error.value = err;
    } finally {
      await onMutateComplete?.call();
    }
  }
}
