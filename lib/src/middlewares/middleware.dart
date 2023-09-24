abstract class Middleware<T> {
  Future<T> process(Future<T> Function() action, MiddlewareChain<T> chain);
}

class MiddlewareChain<T> {
  final List<Middleware<T>> _middlewares;
  int _current = -1;

  MiddlewareChain(this._middlewares);

  Future<T> next(Future<T> Function() action) {
    _current++;
    if (_current < _middlewares.length) {
      return _middlewares[_current].process(action, this);
    } else {
      return action();
    }
  }

  Future<T> applyMiddleware(Future<T> Function() action) {
    return next(action);
  }
}
