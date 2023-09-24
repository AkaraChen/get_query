import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_query/src/middlewares/cancelable.dart';
import 'package:get_query/src/middlewares/middleware.dart';
import 'package:get_query/src/options.dart';

class QueryController<FetchContext, RequestBody, ResponseData>
    extends GetxController {
  final FetchContext context;
  final QueryControllerOptions options;

  QueryController({
    required this.context,
    this.options = const QueryControllerOptions(),
  });

  @protected
  final future = Rxn<Future<ResponseData>>();
  // @protected
  // final cancelable = Rxn<CancelableOperation<ResponseData>>();

  // must be implemented
  Future<ResponseData> callFetch(FetchContext context) async {
    throw UnimplementedError();
  }

  Future<void> fetch() async {
    try {
      final middlewareChain = MiddlewareChain<ResponseData>([
        options.retry.createRetryMiddleware<ResponseData>(),
        CancelableMiddleware(),
      ]);

      var futureWithMiddleware = middlewareChain.applyMiddleware(
        () => callFetch(context),
      );

      future.value = futureWithMiddleware;

      final response = await futureWithMiddleware;
      await onFetchSuccess(response);
      data.value = response;
    } catch (err) {
      await onFetchError(err);
      error.value = err;
    } finally {
      await onFetchComplete();
      future.value = null;
    }
  }

  bool get isFetching => future.value != null;

  final data = Rxn<ResponseData>();

  final error = Rxn<dynamic>();
  bool get isError => error.value != null;

  Future<void> onFetchSuccess(ResponseData data) async {}
  Future<void> onFetchError(dynamic err) async {}
  Future<void> onFetchComplete() async {}
}
