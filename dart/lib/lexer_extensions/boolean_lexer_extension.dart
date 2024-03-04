import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/lexer/token.dart';

final class BooleanToken extends Token {
  @override
  final String value;

  const BooleanToken(this.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  bool operator ==(Object other) =>
      other is BooleanToken && value == other.value;

  @override
  String toString() {
    return value;
  }
}

final class BooleanLexerExtension implements LexerExtension {
  @override
  Token? lex(Scanner scanner) {
    if (scanner.expectString('true')) {
      return BooleanToken('true');
    }

    if (scanner.expectString('false')) {
      return BooleanToken('false');
    }

    return null;
  }
}
