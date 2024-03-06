import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';

final class StringParserExtension implements ParserExtension {
  @override
  dynamic parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current is! StringLiteralToken) {
      return next();
    }

    final value = lexer.current!.value;

    lexer.moveNext();

    return value;
  }
}
