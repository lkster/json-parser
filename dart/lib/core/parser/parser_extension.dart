import 'package:json_parser/core/parser/next_parser_extension.dart';

import '../lexer/token.dart';

abstract interface class ParserExtension {
  Object parse(Iterator<Token?> lexer, NextParserExtension next);
}
