import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/number_lexer_extension.dart';

final class NumberParserExtension implements ParserExtension {
  @override
  Object parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current is! NumberLiteralToken) {
      return next();
    }

    var value = (lexer.current as NumberLiteralToken).value;

    lexer.moveNext();

    if (value.contains('.')) {
      return double.parse(value);
    }

    return int.parse(value);
  }
}
