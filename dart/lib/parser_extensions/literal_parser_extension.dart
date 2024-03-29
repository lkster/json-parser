import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/literal_lexer_extension.dart';

final class LiteralParserExtension implements ParserExtension {
  @override
  dynamic parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current is! LiteralToken) {
      return next();
    }

    final LiteralToken token = lexer.current as LiteralToken;

    lexer.moveNext();

    return switch (token.value) {
      'true' || 'false' => bool.parse(token.value),
      'null' => null,
      // probably would never happen because of strict LiteralLexerExtension
      Object() => throw 'unexpected token ${token.value}',
    };
  }
}
