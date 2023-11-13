import 'dart:async';

import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_query/src/middlewares/cancelable.dart';
import 'package:get_query/src/middlewares/middleware.dart';
import 'package:get_query/src/middlewares/query_client.dart';
import 'package:get_query/src/middlewares/retry.dart';
import 'package:get_query/src/options.dart';

class QueryController<RequestBody, ResponseData> extends GetxController {
  final QueryControllerOptions options;
  final Future<ResponseData> Function(RequestBody body) call;

  final FutureOr<void> Function(ResponseData data)? onFetchSuccess;
  final FutureOr<void> Function(dynamic err)? onFetchError;
  final FutureOr<void> Function()? onFetchComplete;

  QueryController({
    this.options = const QueryControllerOptions(
      retry: RetryConfig(
        maxAttempts: 3,
      ),
    ),
    required this.call,
    this.onFetchSuccess,
    this.onFetchError,
    this.onFetchComplete,
  });

  bool get isFetching => future.value != null;

  @protected
  final future = Rxn<Future<ResponseData>>();

  @protected
  final CancelableCompleter<ResponseData> completer = CancelableCompleter();

  Future<void> fetch(RequestBody body) async {
    if (isFetching) {
      completer.operation.cancel();
    }
    try {
      caller() => call(body);

      final middlewareChain = MiddlewareChain<ResponseData>([
        if (options.queryClient != null)
          QueryClientMiddleware(
            key: options.queryClient!.key,
            triggerUpdate: caller,
            staleTime: options.queryClient!.staleTime,
          ),
        options.retry.createRetryMiddleware<ResponseData>(),
        CancelableMiddleware(completer: completer),
      ]);

      var futureWithMiddleware = middlewareChain.applyMiddleware(caller);

      future.value = futureWithMiddleware;
      final response = await futureWithMiddleware;
      await onFetchSuccess?.call(response);
      setData((data) => response);
    } catch (err) {
      await onFetchError?.call(err);
      error.value = err;
    } finally {
      onFetchComplete?.call();
      future.value = null;
    }
  }

  // Rx reactivity is shallow, so we can't use Rxn here
  // so we need to update manually
  ResponseData? _data;
  ResponseData get data => _data!;
  setData(Function(ResponseData? data) updater) {
    _data = updater(_data);
    update();
  }

  final error = Rxn<dynamic>();
  bool get isError => error.value != null;

  @override
  void onClose() {
    super.onClose();
    if (!completer.isCompleted) {
      completer.operation.cancel();
    }
  }
}
