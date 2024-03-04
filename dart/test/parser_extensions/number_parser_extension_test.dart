import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:json_parser/parser_extensions/number_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([NumberLexerExtension(), DelimiterLexerExtension()]);

  test('should return number if actual token represents number', () {
    final iterator = lexer.lex('123').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    final value = NumberParserExtension().parse(iterator, next);

    expect(value, 123);
  });

  test('should consume token if handled', () {
    final iterator = lexer.lex('123 234').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    NumberParserExtension().parse(iterator, next);

    expect(iterator.current, NumberLiteralToken('234'));
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' ,  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    NumberParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });

  test('should return float number properly', () {
    final iterator = lexer.lex('  2.34').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    final value = NumberParserExtension().parse(iterator, next);

    expect(value, 2.34);
  });
}
