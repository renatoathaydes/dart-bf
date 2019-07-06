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
  final List<Op> ops;

  Loop(this.ops);

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
  List<Op> _rootOps;

  List<Op> _parseOps(Iterator<int> code) {
    List<Op> ops = [];
    while (code.moveNext()) {
      switch (String.fromCharCode(code.current)) {
        case '+':
          ops.add(const Inc(1));
          break;
        case '-':
          ops.add(const Inc(-1));
          break;
        case '>':
          ops.add(const Move(1));
          break;
        case '<':
          ops.add(const Move(-1));
          break;
        case '.':
          ops.add(const Print());
          break;
        case '[':
          ops.add(Loop(_parseOps(code)));
          break;
        case ']':
          return ops;
      }
    }
    return ops;
  }

  void parse(String code) => _rootOps = _parseOps(code.runes.iterator);

  void call(Tape tape) => _rootOps.forEach((op) => op(tape));
}

void execute(String code) {
  final program = Program();
  program.parse(code);
  program(Tape());
}
