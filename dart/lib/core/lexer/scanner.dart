import 'package:json_parser/core/utils/int_extension.dart';

class Scanner {
  final String _source;
  int _position = 0;

  bool get isDone => _position >= _source.length;

  int get position => _position;

  Scanner(this._source);

  int readChar() {
    return _source.codeUnitAt(_position++);
  }

  int? peekChar([int offset = 0]) {
    final index = _position + offset;

    if (!index.inRange(0, _source.length - 1)) {
      return null;
    }

    return _source.codeUnitAt(index);
  }

  void omitWhitespace() {
    while (!isDone && peekChar().isWhitespace) {
      _position++;
    }
  }

  int readNonWhitespace() {
    omitWhitespace();

    return readChar();
  }

  int? peekNonWhitespace() {
    for (var i = 0; !isDone; i++) {
      if (!peekChar(i).isWhitespace) {
        return peekChar(i);
      }
    }

    return null;
  }
}
