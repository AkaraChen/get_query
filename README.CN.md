# Get Query

GetX 中缺失的异步状态管理包装器。

## 动力

1. 使用 GetX 简化异步状态管理。
2. 减少样板代码。

## 特性

1. 简单易用的 API，无需编写 isBusy、error、data 等。
2. 自动处理错误和加载状态。
3. 当 Widget 被释放时，自动取消请求。
4. 支持两种类型：`Query` 和 `Mutation`。
5. 当发生 Exception（非 Error）时自动重试。
6. 使用 QueryClient 存储缓存。

## TODO
1. 分页支持？
2. `InfiniteQueryController` `QueriesController`。
3. Flutter widget 支持。
4. `InitialData`/`PlaceholderData` 支持。
