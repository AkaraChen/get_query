import 'package:get/get.dart';
import 'package:get_query/get_query.dart';
import 'package:flutter/foundation.dart';

class QueryControllerOptions {
  final RetryConfig? retry;

  const QueryControllerOptions({
    this.retry,
  });
}

class QueryController<FetchContext, RequestBody, ResponseData>
    extends GetxController {
  final FetchContext context;
  final QueryControllerOptions? options;

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
      var futureWithRetryOrNot = options?.retry != null
          ? options!.retry!.createRetry(() {
              return callFetch(context);
            })
          : callFetch(context);

      future.value = futureWithRetryOrNot;

      final response = await futureWithRetryOrNot;
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

  @protected
  final data = Rxn<ResponseData>();

  @protected
  final error = Rxn<dynamic>();
  bool get isError => error.value != null;

  Future<void> onFetchSuccess(ResponseData data) async {}
  Future<void> onFetchError(dynamic err) async {}
  Future<void> onFetchComplete() async {}

  @override
  void onClose() {
    super.onClose();
    print('onClose');
  }
}
