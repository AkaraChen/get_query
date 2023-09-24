// ignore_for_file: invalid_use_of_protected_member, empty_catches, argument_type_not_assignable_to_error_handler

import 'package:get_query/get_query.dart';

class SimpleController extends QueryController<String, void, String> {
  SimpleController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    return 'data';
  }
}

class ErrorController extends QueryController<String, void, String> {
  ErrorController({super.context = '', super.options});

  @override
  Future<String> callFetch(String context) async {
    throw Exception('error');
  }
}

class ErrorMutation extends MutationController<String, void, String> {
  ErrorMutation({super.context = '', super.mutationOptions});

  @override
  Future<String> callMutate(String context, void body) async {
    throw Exception('error');
  }
}

void main() {}
