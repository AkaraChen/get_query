import 'package:async/async.dart';
import 'package:get_query/src/middlewares/middleware.dart';

class CancelableMiddleware<T> extends Middleware<T> {
  @override
  Future<T> process(Future<T> Function() action, MiddlewareChain<T> chain) {
    final completer = CancelableCompleter<T>();
    action().then((value) {
      completer.complete(value);
    }).catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.operation.value;
  }
}
