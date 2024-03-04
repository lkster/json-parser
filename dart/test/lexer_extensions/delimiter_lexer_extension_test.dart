import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should return DelimiterToken if delimiter is lexed', () {
    var scanner = Scanner('{[:,]}');
    final delimiterLexer = DelimiterLexerExtension();

    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.openBrace));
    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.openBracket));
    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.colon));
    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.comma));
    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.closeBracket));
    expect(delimiterLexer.lex(scanner), DelimiterToken(Delimiter.closeBrace));
  });

  test('should return null if scanned char is not delimiter', () {
    var scanner = Scanner('te');

    expect(DelimiterLexerExtension().lex(scanner), null);
  });
}
