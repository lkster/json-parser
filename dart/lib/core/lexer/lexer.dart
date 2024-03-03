import 'package:json_parser/core/lexer/token.dart';

import 'lexer_extension.dart';
import 'scanner.dart';

class Lexer {
  final Scanner _scanner;
  final List<LexerExtension> extensions;

  Lexer(String source, this.extensions) : _scanner = Scanner(source);

  bool get isDone => _scanner.isDone;

  Token next() {
    assert(!isDone, 'end of source');

    for (final extension in extensions) {
      final token = extension.lex(_scanner);

      if (token != null) {
        return token;
      }
    }

    throw 'unexpected char ${String.fromCharCode(_scanner.peekChar() ?? 0)}';
  }
}
