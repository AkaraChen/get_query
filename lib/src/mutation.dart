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

  MutationController({
    this.mutationOptions = const MutationControllerOptions(),
    required super.call,
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
      await onMutateSuccess(response, body);
    } catch (err) {
      await onMutateError(err);
      error.value = err as Error;
      // rethrow;
    } finally {
      await onMutateComplete();
    }
  }

  Future<void> onMutateSuccess(ResponseData data, RequestBody body) async {}
  Future<void> onMutateError(dynamic err) async {}
  Future<void> onMutateComplete() async {}
}
