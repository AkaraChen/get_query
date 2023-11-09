import 'package:get_query/get_query.dart';

var simple = () => QueryController(
      call: (body) async {
        return body;
      },
    );

var error = () => QueryController(
      call: (body) => throw Exception('error'),
    );

void main() {}
