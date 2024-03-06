import 'package:json_parser/core/lexer/token.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:json_parser/core/parser/parser_extension.dart';
import 'package:json_parser/lexer_extensions/delimiter_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';

final class ObjectParserExtension implements ParserExtension {
  @override
  parse(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current?.value != Delimiter.openBrace) {
      return next();
    }

    lexer.moveNext();

    final properties = _parseProperties(lexer, next);

    if (lexer.current?.value != Delimiter.closeBrace) {
      throw 'expected , or }';
    }

    lexer.moveNext();

    return properties;
  }

  Map<String, dynamic> _parseProperties(
    Iterator<Token?> lexer,
    NextParserExtension next,
  ) {
    final Map<String, dynamic> properties = {};

    if (lexer.current?.value == Delimiter.closeBrace) {
      return properties;
    }

    while (lexer.current?.value != null) {
      final key = _parseKey(lexer, next);

      properties[key] = next.startOver();

      if (lexer.current?.value != Delimiter.comma) {
        break;
      }

      lexer.moveNext();
    }

    return properties;
  }

  String _parseKey(Iterator<Token?> lexer, NextParserExtension next) {
    if (lexer.current is! StringLiteralToken) {
      throw 'expected key to be string';
    }

    final key = (lexer.current as StringLiteralToken).value;

    lexer.moveNext();

    if (lexer.current?.value != Delimiter.colon) {
      throw 'expected colon after key';
    }

    lexer.moveNext();

    return key;
  }
}
