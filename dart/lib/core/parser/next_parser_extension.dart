/// This is used to call next extension if actual one does not feel it can do something with currently provided token.
/// The reason why it's note done in the same way Lexer is, is because parser extensions can nest things in case of
/// complex structures. Eg. object parser would nest parsing structures within it and include them in itself
///
/// Next thing is why it provides new instance of itself to onNext call. It's to have always same index for current
/// extension:
///
/// next() calls parse() method of next extension and returns its value
///
/// Extension1 calls next <- 0 index
///   Extension2 calls next() <- 1 index
///   Extension2 calls next() one more time <- still 1 index
///     Extension3 calls next() <- 2 index
/// Coming back to Extension1's next <- still 0 index
///
/// Otherwise during such recursion index would be increased for every extension in chain while we always need extension
/// that is directly after current one
///
/// Actual usage in Parser
///
final class NextParserExtension {
  final int index;

  final dynamic Function(int index, NextParserExtension next) onNext;

  NextParserExtension({this.index = 0, required this.onNext});

  dynamic call() {
    return onNext(index, NextParserExtension(index: index + 1, onNext: onNext));
  }

  dynamic startOver() {
    return onNext(0, NextParserExtension(index: 1, onNext: onNext));
  }
}
