import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return NumberLiteralToken if int is lexed', () {
    var scanner = Scanner('123asd');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('123'));

    scanner = Scanner('233 test');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('233'));

    scanner = Scanner('12..32');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('12'));
  });

  test('should return NumberLiteralToken if double is lexed', () {
    var scanner = Scanner('12.34 asd');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('12.34'));

    scanner = Scanner('25.34.23');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('25.34'));
  });

  test('should return null if number is not lexed', () {
    var scanner = Scanner('asd');

    expect(NumberLexerExtension().lex(scanner), null);
  });
}
