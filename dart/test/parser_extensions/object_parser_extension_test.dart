import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';
import 'package:json_parser/parser_extensions/object_parser_extension.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([
    StringLexerExtension(),
    NumberLexerExtension(),
    DelimiterLexerExtension(),
  ]);

  test('should parse empty object properly', () {
    final next = NextParserExtension(onNext: (index, next) => 0);

    expect(
      ObjectParserExtension().parse(
        lexer.lex('{}').iterator..moveNext(),
        next,
      ),
      {},
    );
  });

  test('should parse object with properties properly', () {
    var iterator = lexer.lex('{ "key1": "value", "key2": "value" }').iterator
      ..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      ObjectParserExtension().parse(
        iterator,
        next,
      ),
      {
        'key1': 'value',
        'key2': 'value',
      },
    );
  });

  test('should consume all tokens if handled', () {
    var iterator = lexer.lex('{ "key1": "value", "key2": "value" }').iterator
      ..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    ObjectParserExtension().parse(iterator, next);

    expect(iterator.current, null);
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' "string"  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    ObjectParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });

  test('should throw if object is not closed', () {
    var iterator = lexer.lex('{ "key1": "value", "key2": "value" ').iterator
      ..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      () => ObjectParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('expected , or }'),
    );
  });

  test('should throw if items are not separated by comma', () {
    var iterator = lexer.lex('{ "key1": "value" "key2": "value" }').iterator
      ..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      () => ObjectParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('expected , or }'),
    );
  });

  test('should throw if there is no item after comma', () {
    var iterator = lexer.lex('{ "key1": "value", }').iterator..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      () => ObjectParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('expected key to be string'),
    );
  });

  test('should throw if key is not string', () {
    var iterator = lexer.lex('{ 20: "value"}').iterator..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      () => ObjectParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('expected key to be string'),
    );
  });

  test('should throw if there is no colon after key', () {
    var iterator = lexer.lex('{ "key1" "value" }').iterator..moveNext();

    final next = NextParserExtension(onNext: (index, next) {
      iterator.moveNext();

      return 'value';
    });

    expect(
      () => ObjectParserExtension().parse(
        iterator,
        next,
      ),
      throwsA('expected colon after key'),
    );
  });
}
