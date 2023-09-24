// ignore_for_file: empty_catches

import 'package:test/test.dart';

import '../get_query_test.dart';

void main() {
  test('should be able to fetch data', () async {
    final controller = SimpleController();
    await controller.fetch();
    expect(controller.data, isA<String>());
  });

  test('should be able to have error', () async {
    final controller = ErrorController();
    try {
      await controller.fetch();
    } catch (e) {}
    expect(controller.error, isNot(Null));
  });
}