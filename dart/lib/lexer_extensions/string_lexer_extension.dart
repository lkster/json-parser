import 'package:json_parser/core/lexer/lexer_extension.dart';
import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/utils/char_code.dart';

import '../core/lexer/token.dart';

final class StringLiteralToken extends Token {
  @override
  final String value;

  const StringLiteralToken(this.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  bool operator ==(Object other) =>
      other is StringLiteralToken && value == other.value;

  @override
  String toString() {
    return value;
  }
}

/// This can be handled in two ways:
/// 1. Make DelimiterToken of double quote and lex every word as some token (let's say LiteralToken)
///    pros:
///      - Boolean and null lexing would be able to fall into that.
///      - Hence there would be at least two extensions less - LiteralLexerExtension and DelimiterLexerExtension while
///        getting rid of BooleanLexerExtension and NullLexerExtension
///    cons:
///      - More tokens in iterator and more characters to handle
///        Every word should still be separated by delimiters. Hence instead of just consuming characters until double
///        quote, there would be token for every word, delimiter and anything unhandled just to be joined together
///        in StringParserExtension. Also backslash would also be needed to be considered as a delimiter for easier
///        tracing and making correct escape characters.
///
///  2. make StringLexerExtension that would consume all characters between two double quotes and return it as
///     StringLiteralToken
///     pros:
///       - Less tokens in iterator. There's only one StringLiteralToken instead of (possible) massive load of tokens
///         with words and delimiters only to be joined back to string. I guess this is not always a flaw as some
///         languages' lexers do it this way (I can think of some principle to have as dummy lexer as possible and let
///         parser do its job)
///       - Ready to go prepared string
///     cons:
///       - Ready to go prepared string. Now StringParserExtension is a dummy that just returns further value of
///         StringLiteralToken. Although it marks in parser that it handles such tokens as no other extension does that,
///         it still only takes value and passes through. This is not a big minus though.
///
///  So in the end I went with second approach
///
final class StringLexerExtension implements LexerExtension {
  @override
  StringLiteralToken? lex(Scanner scanner) {
    if (scanner.peekChar() != $doubleQuote) {
      return null;
    }

    scanner.readChar();

    var value = '';

    while (scanner.peekChar() != $doubleQuote && !scanner.isDone) {
      value += _getChar(scanner);
    }

    if (scanner.peekChar() != $doubleQuote) {
      throw 'unterminated string';
    }

    scanner.readChar();

    return StringLiteralToken(value);
  }

  String _getChar(Scanner scanner) {
    if (scanner.peekChar() != $backslash) {
      return String.fromCharCode(scanner.readChar());
    }

    final char = (scanner..readChar()).readChar();

    return switch (char) {
      $lowerN => '\n',
      $lowerR => '\r',
      $lowerT => '\t',
      // and few more escape characters could be implemented here
      // but they're not that much used
      int() => String.fromCharCode(char),
    };
  }
}
