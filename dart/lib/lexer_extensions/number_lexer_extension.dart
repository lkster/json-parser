import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/utils/char_code.dart';
import 'package:json_parser/core/utils/int_extension.dart';

final class NumberLiteralToken extends Token {
  final String value;

  const NumberLiteralToken(this.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  bool operator ==(Object other) => other is NumberLiteralToken && value == other.value;
}

final class NumberLexerExtension extends LexerExtension {
  @override
  Token? lex(Scanner scanner) {
    String value = '';


    while (scanner.peekChar().inRange(CharCode.num0.code, CharCode.num9.code)) {
      value += String.fromCharCode(scanner.readChar());
    }

    return value.isNotEmpty ? NumberLiteralToken(value) : null;
  }
}
