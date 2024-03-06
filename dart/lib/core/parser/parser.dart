import 'package:json_parser/core/lexer/lexer.dart';
import 'package:json_parser/core/parser/next_parser_extension.dart';

import 'parser_extension.dart';

final class Parser {
  final Lexer lexer;
  final List<ParserExtension> extensions;

  Parser(this.lexer, this.extensions);

  dynamic parse(String source) {
    final iterator = lexer.lex(source).iterator;

    iterator.moveNext();

    final nextFunc = NextParserExtension(onNext: (index, next) {
      if (index >= extensions.length) {
        throw 'unexpected token ${iterator.current?.value.toString() ?? 'null'}';
      }

      return extensions.elementAt(index).parse(iterator, next);
    });

    final result = nextFunc();

    if (iterator.current != null) {
      throw 'unexpected token ${iterator.current?.value.toString() ?? 'null'}';
    }

    return result;
  }
}
