import 'dart:io';

class Tape {
  final List<int> _state = [0, 0, 0, 0, 0, 0, 0, 0];
  int _position = 0;

  int get current => _state[_position];

  void inc(int x) => _state[_position] += x;

  void move(int x) {
    _position += x;
    while (_position >= _state.length) {
      _state.add(0);
    }
  }
}

mixin Op {
  void call(Tape tape);
}

class Inc implements Op {
  final int x;

  const Inc(this.x);

  @override
  void call(Tape tape) => tape.inc(x);
}

class Move implements Op {
  final int x;

  const Move(this.x);

  @override
  void call(Tape tape) => tape.move(x);
}

class Loop implements Op {
  final List<Op> ops = [];

  @override
  void call(Tape tape) {
    while (tape.current > 0) {
      ops.forEach((op) => op(tape));
    }
  }
}

class Print implements Op {
  const Print();

  @override
  void call(Tape tape) => stdout.write(String.fromCharCode(tape.current));
}

class Noop implements Op {
  const Noop();

  @override
  void call(Tape tape) {}
}

class Program {
  final _rootOps = <Op>[];
  final _opsStack = <List<Op>>[];

  Program() {
    _opsStack.add(_rootOps);
  }

  Op _parseOp(int value) {
    switch (String.fromCharCode(value)) {
      case '+':
        return const Inc(1);
      case '-':
        return const Inc(-1);
      case '>':
        return const Move(1);
      case '<':
        return const Move(-1);
      case '.':
        return const Print();
      case '[':
        return Loop();
      case ']':
        return null;
      default:
        return const Noop();
    }
  }

  void parse(List<int> code) {
    List<Op> ops = _opsStack.last;
    for (var c in code) {
      var op = _parseOp(c);
      if (op == null) {
        // loop ended
        _opsStack.removeLast();
        ops = _opsStack.last;
      } else {
        ops.add(op);
        if (op is Loop) {
          ops = op.ops;
          _opsStack.add(ops);
        }
      }
    }
  }

  void call(Tape tape) => _rootOps.forEach((op) => op(tape));
}

void execute(Stream<List<int>> code) async {
  final program = Program();
  await for (final bytes in code) {
    program.parse(bytes);
  }
  program(Tape());
}
