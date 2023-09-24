import 'package:async/async.dart';
import 'package:get_query/src/middlewares/middleware.dart';

class CancelableMiddleware<T> extends Middleware<T> {
  final CancelableCompleter<T> completer;

  CancelableMiddleware({required this.completer});

  @override
  Future<T> process(Future<T> Function() action, MiddlewareChain<T> chain) {
    action().then((value) {
      completer.complete(value);
    }).catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.operation.value;
  }
}
