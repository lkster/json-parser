import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return StringLiteralToken if string is lexed', () {
    final scanner = Scanner('"some string"');

    expect(
      StringLexerExtension().lex(scanner),
      StringLiteralToken('some string'),
    );
  });

  test('should return null if number is not lexed', () {
    final scanner = Scanner('123123');

    expect(StringLexerExtension().lex(scanner), null);
  });

  test('should properly lex escaped double quote', () {
    final scanner = Scanner('"some \\" string"');

    expect(
      StringLexerExtension().lex(scanner),
      StringLiteralToken('some " string'),
    );
  });

  test('should properly lex escape characters', () {
    final scanner = Scanner('"\\n \\t \\r \\\\ \\k"');

    expect(
      StringLexerExtension().lex(scanner),
      StringLiteralToken('\n \t \r \\ k'),
    );
  });

  test('should throw if string is not closed before end of source', () {
    final scanner = Scanner('"something');

    expect(
      () => StringLexerExtension().lex(scanner),
      throwsA('unterminated string'),
    );
  });
}
