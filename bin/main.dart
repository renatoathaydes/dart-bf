import 'dart:io';

import 'package:dart_bf/dart_bf.dart';

main(List<String> args) {
  execute(File(args[0]).openRead());
}
