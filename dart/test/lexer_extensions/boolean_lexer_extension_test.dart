import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/boolean_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return BooleanToken if boolean is lexed', () {
    var scanner = Scanner('true');

    expect(BooleanLexerExtension().lex(scanner), BooleanToken('true'));

    scanner = Scanner('falseasd');

    expect(BooleanLexerExtension().lex(scanner), BooleanToken('false'));
  });

  test('should return null if boolean is not lexed', () {
    var scanner = Scanner('123asd');

    expect(BooleanLexerExtension().lex(scanner), null);
  });
}
