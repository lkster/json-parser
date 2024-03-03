import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should lex all tokens', () {
    var lexer = Lexer([NumberLexerExtension()]).lex('123 345').iterator;

    expect((lexer..moveNext()).current, NumberLiteralToken('123'));
    expect((lexer..moveNext()).current, NumberLiteralToken('345'));
    expect((lexer..moveNext()).current, null);
  });

  test('should throw if char is not handled by any of extensions', () {
    var lexer = Lexer([NumberLexerExtension()]).lex('.').iterator;

    expect(() => (lexer..moveNext()).current, throwsA('unexpected char .'));
  });
}
