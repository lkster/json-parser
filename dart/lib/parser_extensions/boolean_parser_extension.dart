import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/boolean_lexer_extension.dart';

final class BooleanParserExtension implements ParserExtension {
  @override
  Object parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current is! BooleanToken) {
      return next();
    }

    final BooleanToken token = lexer.current as BooleanToken;

    lexer.moveNext();

    return token.value == 'true' ? true : false;
  }
}
