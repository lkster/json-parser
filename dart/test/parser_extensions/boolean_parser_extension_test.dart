import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/boolean_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/parser_extensions/boolean_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([BooleanLexerExtension(), DelimiterLexerExtension()]);
  final next = NextParserExtension(onNext: (index, next) => 0);

  test('should return boolean if actual token represents boolean', () {
    final trueValue = BooleanParserExtension().parse(
      lexer.lex('true').iterator..moveNext(),
      next,
    );

    final falseValue = BooleanParserExtension().parse(
      lexer.lex('  \nfalse').iterator..moveNext(),
      next,
    );

    expect(trueValue, true);
    expect(falseValue, false);
  });

  test('should consume token if handled', () {
    final iterator = lexer.lex('  true false').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    BooleanParserExtension().parse(iterator, next);

    expect(iterator.current, BooleanToken('false'));
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' ,  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    BooleanParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });
}
