import 'package:json_parser/lexer_extensions/boolean_lexer_extension.dart';
import 'package:json_parser/parser_extensions/boolean_parser_extension.dart';

import 'core/lexer/lexer.dart';
import 'core/parser/parser.dart';
import 'lexer_extensions/delimiter_lexer_extension.dart';
import 'lexer_extensions/number_lexer_extension.dart';
import 'parser_extensions/number_parser_extension.dart';

final _lexerExtensions = [
  DelimiterLexerExtension(),
  NumberLexerExtension(),
  BooleanLexerExtension(),
];

final _parserExtensions = [
  NumberParserExtension(),
  BooleanParserExtension(),
];

final _lexer = Lexer(_lexerExtensions);
final _parser = Parser(_lexer, _parserExtensions);

Object parseJson(String source) => _parser.parse(source);
