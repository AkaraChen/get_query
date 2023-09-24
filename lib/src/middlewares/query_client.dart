import 'dart:async';

import 'package:get_query/get_query.dart';

final queryClient = QueryClient();

class QueryClientMiddleware<T> extends Middleware<T> {
  final QueryKey key;
  final Duration staleTime;
  final FutureOr<void> Function() triggerUpdate;

  static const _defaultDuration = Duration(minutes: 1);

  QueryClientMiddleware({
    required this.key,
    this.staleTime = _defaultDuration,
    required this.triggerUpdate,
  });

  @override
  Future<T> process(Future<T> Function() action, MiddlewareChain<T> chain) {
    final query = queryClient.get<T>(key);
    final queryExists = query != null;
    if (queryExists && query.isStale == false) {
      // Should I exit the chain here?
      return Future.value(query.data);
    }
    return chain.next(
      () => action().then((value) {
        if (queryExists) {
          queryClient.set<T>(
            key,
            value,
            staleTime,
          );
        } else {
          queryClient.createEntry<T>(
            key,
            value,
            staleTime,
            triggerUpdate,
          );
        }
        return value;
      }),
    );
  }
}
