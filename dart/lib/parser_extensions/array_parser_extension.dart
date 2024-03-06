import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';

class ArrayParserExtension implements ParserExtension {
  @override
  dynamic parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current?.value != Delimiter.openBracket) {
      return next();
    }

    lexer.moveNext();

    final array = _parseItems(lexer, next);

    if (lexer.current?.value != Delimiter.closeBracket) {
      throw 'expected , or ]';
    }

    lexer.moveNext();

    return array;
  }

  List<Object> _parseItems(Iterator<Token?> lexer, NextParserExtension next) {
    final List<Object> items = [];

    if (lexer.current?.value == Delimiter.closeBracket) {
      return items;
    }

    while (lexer.current?.value != null) {
      items.add(next.startOver());

      if (lexer.current?.value != Delimiter.comma) {
        break;
      }

      lexer.moveNext();
    }

    return items;
  }
}
