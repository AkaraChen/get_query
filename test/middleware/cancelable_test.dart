import 'package:get_query/get_query.dart';
import 'package:test/test.dart';

void main() {
  test('cancelable', () {
    var flag = 0;
    var q = QueryController(
      call: (body) async {
        flag++;
        await Future.delayed(Duration(seconds: 1));
        return body;
      },
    );
    q.fetch('');
    q.dispose();
    expect(flag, 1);
  });
}
