// import 'package:get_query/get_query.dart';

// class MutationControllerOptions extends QueryControllerOptions {}

// // Use for doing some async task
// class MutationController<MutationContext, RequestBody, ResponseData>
//     extends QueryController<MutationContext, RequestBody, ResponseData> {
//   final MutationControllerOptions? mutationOptions;
//   MutationController({
//     required super.context,
//     this.mutationOptions,
//   });

//   get isMutating => isFetching;

//   @override
//   Future<void> fetch() async {
//     throw UnsupportedError('Use mutate() instead');
//   }

//   Future<void> mutate(RequestBody body) async {
//     try {
//       var futureWithRetryOrNot = options?.retry != null
//           ? options!.retry!
//               .createRetryMiddleware(() => callMutate(context, body))
//           : callMutate(context, body);
//       future.value = futureWithRetryOrNot;
//       final response = await futureWithRetryOrNot;
//       await onMutateSuccess(response, body);
//     } catch (err) {
//       await onMutateError(err);
//       error.value = err as Error;
//       // rethrow;
//     } finally {
//       await onMutateComplete();
//       isMutating.value = false;
//     }
//   }

//   // must be implemented
//   Future<ResponseData> callMutate(
//       MutationContext context, RequestBody body) async {
//     throw UnimplementedError();
//   }

//   Future<void> onMutateSuccess(ResponseData data, RequestBody body) async {}
//   Future<void> onMutateError(dynamic err) async {}
//   Future<void> onMutateComplete() async {}
// }
