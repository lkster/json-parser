import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:test/test.dart';

void main() {

  test('should return NumberLiteralToken if number is lexed', () {
    var scanner = Scanner('123asd');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('123'));

    scanner = Scanner('   \n\t233 test');

    expect(NumberLexerExtension().lex(scanner), NumberLiteralToken('233'));
  });

  test('should return null if number is not lexed', () {
    var scanner = Scanner('asd');

    expect(NumberLexerExtension().lex(scanner), null);
  });
}
