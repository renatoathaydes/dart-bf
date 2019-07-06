import 'dart:convert';
import 'dart:io';

import 'package:dart_bf/dart_bf.dart';

main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln("Error: expected one argument, given ${args.length}\n"
        "Usage: dart-bf <bf-file>");
    exit(2);
  }
  execute(await File(args[0]).readAsString(encoding: ascii));
}
