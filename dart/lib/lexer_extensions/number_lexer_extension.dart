import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/utils/char_code.dart';
import 'package:json_parser/core/utils/int_extension.dart';

final class NumberLiteralToken extends Token {
  @override
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
    String value = _lexSymbol(scanner) + _lexDigits(scanner);

    if (value.isEmpty) {
      return null;
    }

    if (value == '-') {
      throw 'expected digit after minus';
    }

    value += _lexDecimals(scanner) + _lexExponent(scanner);

    return NumberLiteralToken(value);
  }

  String _lexDigits(Scanner scanner) {
    var value = '';

    while (_isDigit(scanner.peekChar())) {
      value += String.fromCharCode(scanner.readChar());
    }

    return value;
  }

  /// I guess redundant plus is not supported by JSON? Unless it's exponent but for simplicity let's support that for
  /// now (this is also used when lexing exponent)
  String _lexSymbol(Scanner scanner) {
    if (![$plus, $minus].contains(scanner.peekChar())) {
      return '';
    }

    return String.fromCharCode(scanner.readChar());
  }

  String _lexDecimals(Scanner scanner) {
    if (scanner.peekChar() != $dot) {
      return '';
    }

    scanner.readChar();

    final value = '.${_lexDigits(scanner)}';

    if (value.endsWith('.')) {
      throw 'expected digit after decimal point';
    }

    return value;
  }

  String _lexExponent(Scanner scanner) {
    if (![$upperE, $lowerE].contains(scanner.peekChar())) {
      return '';
    }

    scanner.readChar();

    var value = 'e${_lexSymbol(scanner)}${_lexDigits(scanner)}';

    if (RegExp(r'[eE+-]$').hasMatch(value)) {
      throw 'expected digit after exponent';
    }

    return value;
  }

  bool _isDigit(int? charCode) => charCode?.inRange($num0, $num9) ?? false;
}
