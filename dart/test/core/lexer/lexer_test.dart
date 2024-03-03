import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should lex all tokens', () {
    var lexer = Lexer('123 345', [NumberLexerExtension()]);

    expect(lexer.next(), NumberLiteralToken('123'));
    expect(lexer.next(), NumberLiteralToken('345'));
  });

  test('should have isDone flag set properly', () {
    var lexer = Lexer('123 345 2', [NumberLexerExtension()]);

    expect(lexer.isDone, false);

    lexer.next();

    expect(lexer.isDone, false);

    lexer.next();

    expect(lexer.isDone, false);

    lexer.next();

    expect(lexer.isDone, true);
  });

  test('should throw if calling next() after lexer is done', () {
    var lexer = Lexer('123', [NumberLexerExtension()]);
    lexer.next();

    expect(() => lexer.next(), throwsA(isA<AssertionError>()));
  });

  test('should throw if char is not handled by any of extensions', () {
    var lexer = Lexer('.', [NumberLexerExtension()]);

    expect(() => lexer.next(), throwsA('unexpected char .'));

  });
}
