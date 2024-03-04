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
  bool operator ==(Object other) =>
      other is NumberLiteralToken && value == other.value;

  @override
  String toString() {
    return value;
  }
}

final class NumberLexerExtension implements LexerExtension {
  @override
  Token? lex(Scanner scanner) {
    String value = _lexDigits(scanner);

    if (value.isEmpty) {
      return null;
    }

    if (scanner.peekChar() == CharCode.dot.code && _isDigit(scanner.peekChar(1))) {
      scanner.readChar();
      value += '.${_lexDigits(scanner)}';
    }

    return NumberLiteralToken(value);
  }

  String _lexDigits(Scanner scanner) {
    var value = '';

    while (_isDigit(scanner.peekChar())) {
      value += String.fromCharCode(scanner.readChar());
    }

    return value;
  }

  bool _isDigit(int? charCode) => charCode?.inRange(CharCode.num0.code, CharCode.num9.code) ?? false;
}
