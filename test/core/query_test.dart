// ignore_for_file: empty_catches

import 'package:test/test.dart';

import '../t_utils.dart';

void main() {
  test('should be able to fetch data', () async {
    final controller = simple();
    await controller.fetch('');
    expect(controller.data, isA<String>());
  });

  test('should be able to have error', () async {
    final controller = error();
    try {
      await controller.fetch('');
    } catch (e) {}
    expect(controller.error, isNot(Null));
  });
}
