import 'core/lexer/lexer.dart';
import 'core/parser/parser.dart';
import 'lexer_extensions/delimiter_lexer_extension.dart';
import 'lexer_extensions/number_lexer_extension.dart';
import 'parser_extensions/number_parser_extension.dart';

final _lexerExtensions = [
  DelimiterLexerExtension(),
  NumberLexerExtension(),
];

final _parserExtensions = [
  NumberParserExtension(),
];

final _lexer = Lexer(_lexerExtensions);
final _parser = Parser(_lexer, _parserExtensions);

Object parseJson(String source) => _parser.parse(source);
