import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/literal_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/parser_extensions/literal_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([LiteralLexerExtension(), DelimiterLexerExtension()]);
  final next = NextParserExtension(onNext: (index, next) => 0);

  test('should return boolean if actual token represents boolean', () {
    final trueValue = LiteralParserExtension().parse(
      lexer.lex('true').iterator..moveNext(),
      next,
    );

    final falseValue = LiteralParserExtension().parse(
      lexer.lex('  \nfalse').iterator..moveNext(),
      next,
    );

    expect(trueValue, true);
    expect(falseValue, false);
  });

  test('should return null if actual token represents null', () {
    expect(
      LiteralParserExtension().parse(
        lexer.lex('null').iterator..moveNext(),
        next,
      ),
      null,
    );
  });

  test('should consume token if handled', () {
    final iterator = lexer.lex('  true false').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    LiteralParserExtension().parse(iterator, next);

    expect(iterator.current, LiteralToken('false'));
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' ,  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    LiteralParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });

  test("should throw if LiteralToken's value is not supported", () {
    expect(
      () => LiteralParserExtension().parse(
        lexer.lex('asdf').iterator..moveNext(),
        next,
      ),
      throwsA('unexpected char a (0x61)'),
    );
  });
}
