import 'package:get_query/get_query.dart';
import 'package:get_query/src/middlewares/middleware.dart';
import 'package:get_query/src/middlewares/retry.dart';

class MutationControllerOptions extends QueryControllerOptions {
  const MutationControllerOptions({
    retry = const RetryConfig(maxAttempts: 0),
  }) : super(retry: retry);
}

// Use for doing some async task
class MutationController<MutationContext, RequestBody, ResponseData>
    extends QueryController<MutationContext, RequestBody, ResponseData> {
  final MutationControllerOptions mutationOptions;

  MutationController({
    required super.context,
    this.mutationOptions = const MutationControllerOptions(),
  });

  bool get isMutating => isFetching;

  @override
  Future<void> fetch() async {
    throw UnsupportedError('Use mutate() instead');
  }

  Future<void> mutate(RequestBody body) async {
    try {
      final middlewareChain = MiddlewareChain<ResponseData>([
        options.retry.createRetryMiddleware<ResponseData>(),
      ]);

      var futureWithMiddleware = middlewareChain.applyMiddleware(
        () => callFetch(context),
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

  // must be implemented
  Future<ResponseData> callMutate(
      MutationContext context, RequestBody body) async {
    throw UnimplementedError();
  }

  Future<void> onMutateSuccess(ResponseData data, RequestBody body) async {}
  Future<void> onMutateError(dynamic err) async {}
  Future<void> onMutateComplete() async {}
}
