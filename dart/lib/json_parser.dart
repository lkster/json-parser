import 'package:json_parser/lexer_extensions/literal_lexer_extension.dart';
import 'package:json_parser/lexer_extensions/string_lexer_extension.dart';
import 'package:json_parser/parser_extensions/array_parser_extension.dart';
import 'package:json_parser/parser_extensions/literal_parser_extension.dart';
import 'package:json_parser/parser_extensions/string_parser_extension.dart';

import 'core/lexer/lexer.dart';
import 'core/parser/parser.dart';
import 'lexer_extensions/delimiter_lexer_extension.dart';
import 'lexer_extensions/number_lexer_extension.dart';
import 'parser_extensions/number_parser_extension.dart';

final _lexerExtensions = [
  DelimiterLexerExtension(),
  NumberLexerExtension(),
  LiteralLexerExtension(),
  StringLexerExtension(),
];

final _parserExtensions = [
  NumberParserExtension(),
  LiteralParserExtension(),
  StringParserExtension(),
  ArrayParserExtension(),
];

final _lexer = Lexer(_lexerExtensions);
final _parser = Parser(_lexer, _parserExtensions);

dynamic parseJson(String source) => _parser.parse(source);
