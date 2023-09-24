abstract class Middleware {
  Future process(Future Function() action, MiddlewareChain chain);
}

class MiddlewareChain<T> {
  final List<Middleware> _middlewares;
  int _current = -1;

  MiddlewareChain(this._middlewares);

  Future<T> next(Future<T> Function() action) {
    _current++;
    if (_current < _middlewares.length) {
      return _middlewares[_current].process(action, this) as Future<T>;
    } else {
      return action();
    }
  }

  Future<T> applyMiddleware(Future<T> Function() action) {
    final chain = MiddlewareChain<T>(_middlewares);
    return chain.next(action);
  }
}
