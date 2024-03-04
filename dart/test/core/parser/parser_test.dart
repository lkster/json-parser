import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/parser.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';
import 'package:json_parser/parser_extensions/number_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  final lexer = Lexer([NumberLexerExtension(), DelimiterLexerExtension()]);
  final parser = Parser(lexer, [NumberParserExtension()]);

  test('should use extensions to parse source properly', () {
    expect(parser.parse('123'), 123);
    expect(parser.parse('12.45'), 12.45);
  });

  test('should throw if unsupported token is provided', () {
    expect(() => parser.parse('}'), throwsA('unexpected token }'));
  });

  test('should throw if there are tokens left after parsing', () {
    expect(() => parser.parse('123 321'), throwsA('unexpected token 321'));
  });
}
