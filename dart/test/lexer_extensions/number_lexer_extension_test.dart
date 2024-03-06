import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return NumberLiteralToken if int is lexed', () {
    var scanner = Scanner('123asd');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('123'));

    scanner = Scanner('233 test');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('233'));
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

    scanner = Scanner('e20');

    expect(NumberLexerExtension().lex(scanner), null);
  });

  test('should properly lex negative numbers', () {
    var scanner = Scanner('-1');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('-1'));

    scanner = Scanner('-22.23');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('-22.23'));
  });

  test('should properly lex exponent', () {
    var scanner = Scanner('2e10');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('2e10'));

    scanner = Scanner('2e+10');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('2e+10'));

    scanner = Scanner('2e-10');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('2e-10'));
  });

  test('should throw if there is no digit directly after minus', () {
    var scanner = Scanner('-  2');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after minus'));
  });

  test('should throw if there is incorrectly used exponent', () {
    var scanner = Scanner('2e');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after exponent'));

    scanner = Scanner('2e+');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after exponent'));

    scanner = Scanner('2e-');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after exponent'));

    scanner = Scanner('2e 20');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after exponent'));
  });
  
  test('should throw if there are no digits after decimal point', () {
    var scanner = Scanner('12. 32');

    expect(() => NumberLexerExtension().lex(scanner), throwsA('expected digit after decimal point'));
  });
}
