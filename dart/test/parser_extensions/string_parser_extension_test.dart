import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';
import 'package:json_parser/parser_extensions/string_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([StringLexerExtension(), DelimiterLexerExtension()]);

  test('should return string if actual token represents string', () {
    final iterator = lexer.lex('"some string"').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    final value = StringParserExtension().parse(iterator, next);

    expect(value, 'some string');
  });

  test('should consume token if handled', () {
    final iterator = lexer.lex('"some string" "other string"').iterator;
    final next = NextParserExtension(onNext: (index, next) => 0);

    iterator.moveNext();

    StringParserExtension().parse(iterator, next);

    expect(iterator.current, StringLiteralToken('other string'));
  });

  test('should call next func if actual token is not supported', () {
    final iterator = lexer.lex(' ,  ').iterator;

    var nextCalled = false;
    final next = NextParserExtension(onNext: (index, next) {
      nextCalled = true;

      return 0;
    });

    iterator.moveNext();

    StringParserExtension().parse(iterator, next);

    expect(nextCalled, true);
  });
}
