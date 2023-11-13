import 'package:get_query/get_query.dart';
import 'package:test/test.dart';

void main() {
  test('should able to run', () {
    final c = MutationController(call: (body) async {
      return body;
    });
    c.mutate('');
    expect(c.isError, false);
  });

  test('should throw when error', () {
    final c = MutationController(call: (body) {
      throw Exception('error');
    });
    try {
      c.mutate('');
    } catch (e) {
      expect(e, isNot(null));
    }
  });
}
