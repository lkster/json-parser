import 'scanner.dart';
import 'token.dart';

abstract interface class LexerExtension {
  Token? lex(Scanner scanner);
}
