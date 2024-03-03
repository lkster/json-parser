import 'scanner.dart';
import 'token.dart';

abstract class LexerExtension {
  Token? lex(Scanner scanner);
}
