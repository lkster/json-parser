import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/literal_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return boolean as LiteralToken if boolean is lexed', () {
    var scanner = Scanner('true');

    expect(LiteralLexerExtension().lex(scanner), LiteralToken('true'));

    scanner = Scanner('falseasd');

    expect(LiteralLexerExtension().lex(scanner), LiteralToken('false'));
  });

  test('should return null as LiteralToken if null is lexed', () {
    var scanner = Scanner('null');

    expect(LiteralLexerExtension().lex(scanner), LiteralToken('null'));
  });

  test('should return null if supported literal is not lexed', () {
    var scanner = Scanner('123asd');

    expect(LiteralLexerExtension().lex(scanner), null);
  });
}
