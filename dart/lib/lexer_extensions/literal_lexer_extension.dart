import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/lexer/token.dart';

final class LiteralToken extends Token {
  @override
  final String value;

  const LiteralToken(this.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  bool operator ==(Object other) =>
      other is LiteralToken && value == other.value;

  @override
  String toString() {
    return value;
  }
}

final class LiteralLexerExtension implements LexerExtension {
  @override
  Token? lex(Scanner scanner) {
    if (scanner.expectString('true')) {
      return LiteralToken('true');
    }

    if (scanner.expectString('false')) {
      return LiteralToken('false');
    }

    if (scanner.expectString('null')) {
      return LiteralToken('null');
    }

    return null;
  }
}
