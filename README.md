# dart-bf

A Brainfuck implementation in Dart.

To activate dart-bf:

```
$ pub global activate dart-bf
```

To run a bf program:

```
$ dart-bf <bf-file>
```

## Compiling AOT

To compile the bf interpreter to native machine code:

```
$ dart2aot bin/dart-bf.dart dart-bf.aot
```

To run:

```
$ dartaotruntime dart-bf.aot bf/hello.bf
```

> Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
