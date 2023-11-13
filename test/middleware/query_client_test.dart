import 'package:get/get.dart';
import 'package:get_query/get_query.dart';
import 'package:test/test.dart';

void main() {
  test("cache should work", () async {
    final v = 0.obs;
    final c = QueryController(
      call: (body) async {
        v.value++;
        return body;
      },
      options: QueryControllerOptions(
        queryClient: QueryClientOptions(key: ["test"]),
      ),
    );
    await c.fetch(1);
    await c.fetch(1);
    expect(v.value, 1);
  });
}
