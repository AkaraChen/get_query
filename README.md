# Get Query

[简体中文](./README.CN.md)

```
🧪 Work in progress
```

The missing async state management wrapper for GetX.

## Motivation

1. Simplify the async state management with GetX.
2. Reduce boilerplate code.

## Features

1. Simple and easy to use API, no need write isBusy, error, data, etc.
2. Automatically handle error and loading state.
3. Support two type: `Query` and `Mutation`.
4. Automatically cancel the query when the widget is disposed.
5. Auto retry when exception(not error) occurs.
6. Use `QueryClient` to store cache.

## TODO

1. Pagination support?
2. `InfiniteQueryController` `QueriesController`.
3. Flutter widget support.
4. `InitialData`/`PlaceholderData` support.
