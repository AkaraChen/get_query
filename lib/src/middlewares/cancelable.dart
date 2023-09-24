import 'package:async/async.dart';
import 'package:get_query/src/middlewares/middleware.dart';

class CancelableMiddleware extends Middleware {
  @override
  Future process(Future Function() action, MiddlewareChain chain) {
    final completer = CancelableCompleter();
    action().then((value) {
      completer.complete(value);
    }).catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.operation.valueOrCancellation();
  }
}
