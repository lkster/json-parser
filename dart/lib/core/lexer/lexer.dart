import 'package:json_parser/core/lexer/token.dart';

import 'lexer_extension.dart';
import 'scanner.dart';

class Lexer {
  final List<LexerExtension> extensions;

  Lexer(this.extensions);

  Iterable<Token?> lex(String source) sync* {
    final scanner = Scanner(source);

    while (!scanner.isDone) {
      yield _next(scanner);
    }
  }

  Token _next(Scanner scanner) {
    scanner.omitWhitespace();

    for (final extension in extensions) {
      final token = extension.lex(scanner);

      scanner.omitWhitespace();

      if (token != null) {
        return token;
      }
    }

    throw 'unexpected char ${String.fromCharCode(scanner.peekChar() ?? 0)} (0x${scanner.peekChar()?.toRadixString(16)})';
  }
}
