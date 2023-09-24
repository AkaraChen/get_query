# Get Query

The missing async state management wrapper for GetX.

## Motivation

1. Simplify the async state management with GetX.
2. Reduce boilerplate code.

## Features

1. Simple and easy to use API, no need write isBusy, error, data, etc.
2. Automatically handle error and loading state.
3. Support two type: `Query` and `Mutation`.

## TODO

1. Should we have a pagination support?
2. Should we have a `QueryClient` to store cache?
3. `InfiniteQueryController` `QueriesController`.
4. Flutter widget support.
5. InitialData/PlaceholderData support.
6. Automatically cancel the request when the widget is disposed.
