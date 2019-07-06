import 'dart:convert';
import 'dart:io';

import 'package:dart_bf/dart_bf.dart';

main(List<String> args) async {
  execute(await File(args[0]).readAsString(encoding: ascii));
}
