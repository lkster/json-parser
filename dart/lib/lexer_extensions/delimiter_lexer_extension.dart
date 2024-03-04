import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/utils/char_code.dart';

enum Delimiter {
  comma(','),
  colon(':'),
  doubleQuote('"'),
  openBracket('['),
  closeBracket(']'),
  openBrace('{'),
  closeBrace('}');

  const Delimiter(this.symbol);

  final String symbol;

  @override
  String toString() => symbol;
}


final class DelimiterToken extends Token {
  @override
  final Delimiter value;

  const DelimiterToken(this.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  bool operator ==(Object other) => other is DelimiterToken && value == other.value;

  @override
  String toString() {
    return value.symbol;
  }
}

final class DelimiterLexerExtension implements LexerExtension {
  final _delimiters = {
    CharCode.openBrace.code: Delimiter.openBrace,
    CharCode.closeBrace.code: Delimiter.closeBrace,
    CharCode.openBracket.code: Delimiter.openBracket,
    CharCode.closeBracket.code: Delimiter.closeBracket,
    CharCode.colon.code: Delimiter.colon,
    CharCode.comma.code: Delimiter.comma,
    CharCode.doubleQuote.code: Delimiter.doubleQuote,
  };

  @override
  Token? lex(Scanner scanner) {
    if (!_delimiters.containsKey(scanner.peekNonWhitespace())) {
      return null;
    }

    final delimiter = _delimiters[scanner.readChar()]!;

    return DelimiterToken(delimiter);
  }

}
