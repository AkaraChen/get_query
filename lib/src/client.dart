import 'dart:async';

typedef QueryKey = List<String>;

extension QueryKeyExtension on QueryKey {
  String get _clientKey => join('/');
}

class Query<T> {
  T data;
  QueryKey key;

  late DateTime date;
  bool get isStale => date.isBefore(DateTime.now());

  FutureOr<void> Function() triggerUpdate;

  Query({
    required this.key,
    required this.data,
    required Duration staleTime,
    required this.triggerUpdate,
  }) {
    date = DateTime.now().add(staleTime);
  }
}

class QueryClient {
  final Map<String, Query> _cache = {};

  Query<T>? get<T>(QueryKey key) {
    final query = _cache[key._clientKey];
    if (query == null) {
      return null;
    }
    if (query.isStale) {
      invalidate(query.key);
    }
    return query as Query<T>;
  }

  void createEntry<T>(
    QueryKey key,
    T data,
    Duration staleTime,
    FutureOr<void> Function() triggerUpdate,
  ) {
    final queryExists = _cache.containsKey(key._clientKey);
    if (queryExists) {
      throw Exception('Query already exists');
    }
    _cache[key._clientKey] = Query<T>(
      key: key,
      data: data,
      staleTime: staleTime,
      triggerUpdate: triggerUpdate,
    );
  }

  void set<T>(QueryKey key, T data, Duration staleTime) {
    final queryExists = _cache.containsKey(key._clientKey);
    if (queryExists) {
      // Need to call setData to tell the app to rerender
      final query = _cache[key._clientKey] as Query<T>;
      query.data = data;
      query.date = DateTime.now().add(staleTime);
      query.triggerUpdate();
    } else {
      // Need to create a new entry
      throw Exception('Query does not exist');
    }
  }

  void clear() {
    _cache.clear();
  }

  void invalidate(QueryKey key) {
    final query = _cache[key._clientKey];
    if (query != null) {
      query.triggerUpdate();
    }
    _cache.remove(key._clientKey);
  }

  // TODO: implement prefetch
  // TODO: support placeholderData and initialData
}
