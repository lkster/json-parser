import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';
import 'package:json_parser/parser_extensions/array_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([StringLexerExtension(), DelimiterLexerExtension()]);

  test('should parse array properly', () {
    var iterator = lexer.lex('[]').iterator..moveNext();
    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'some string';
    });

    expect(
      ArrayParserExtension().parse(
        iterator,
        next,
      ),
      [],
    );

    iterator = lexer.lex('["some string", "some string"]').iterator..moveNext();

    expect(
      ArrayParserExtension().parse(
        iterator,
        next,
      ),
      ['some string', 'some string'],
    );
  });

  test('should consume all tokens if handled', () {
    final iterator = lexer.lex('["some string"] "string"').iterator;
    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'some string';
    });

    iterator.moveNext();

    ArrayParserExtension().parse(iterator, next);

    expect(iterator.current, StringLiteralToken('string'));
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' "string"  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    ArrayParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });

  test('should throw if array is not closed', () {
    final next = NextParserExtension(onNext: (index, next) => 'some string');

    expect(
      () => ArrayParserExtension().parse(
        lexer.lex('["some string", "some string"').iterator..moveNext(),
        next,
      ),
      throwsA('expected , or ]'),
    );
  });

  test('should throw if items are not separated by comma', () {
    final next = NextParserExtension(onNext: (index, next) => 'some string');

    expect(
      () => ArrayParserExtension().parse(
        lexer.lex('["some string" "some string"]').iterator..moveNext(),
        next,
      ),
      throwsA('expected , or ]'),
    );
  });

  test('should throw if there is no item after comma', () {
    final iterator = lexer.lex('["some string", ]').iterator..moveNext();
    final next = NextParserExtension(onNext: (index, next) {
      if (iterator.current is StringLiteralToken) {
        iterator.moveNext();

        return 'some string';
      }

      throw 'unexpected token';
    });

    expect(
      () => ArrayParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('unexpected token'),
    );
  });
}
