import 'package:json_parser/core/parser/next_parser_extension.dart';
import 'package:test/test.dart';

void main() {
  test('should call onNext function', () {
    var called = false;
    final next = NextParserExtension(onNext: (index, next) {
      called = true;

      return 0;
    });

    next();

    expect(called, true);
  });

  test('should not change its index value on next() call', () {
    final next = NextParserExtension(onNext: (index, next) => 0);

    next();
    next();
    next();

    expect(next.index, 0);
  });

  test('should provide new NextParserExtension with increased index', () {
    late NextParserExtension next;

    next = NextParserExtension(onNext: (index, nextFunc) {
      next = nextFunc;

      return 0;
    });

    next();
    next();
    next();

    expect(next.index, 3);
  });

  test(
      'should reset index in returned NextParserExtension when startOver is called',
      () {
    late NextParserExtension next;

    next = NextParserExtension(onNext: (index, nextFunc) {
      next = nextFunc;

      return 0;
    });

    next();
    next();
    next();
    next.startOver();

    // onNext is instantly called with 0 index hence returned nextFunc has already increased value
    expect(next.index, 1);
  });
}
