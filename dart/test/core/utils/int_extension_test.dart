import 'package:json_parser/core/utils/int_extension.dart';
import 'package:test/test.dart';

void main() {
  test('isSpace should properly declare whether int represents space', () {
    expect(0x20.isSpace, true);
    expect(0x21.isSpace, false);
    expect(0x09.isSpace, false);
  });

  test('isTab should properly declare whether int represents tab', () {
    expect(0x09.isTab, true);
    expect(0x20.isTab, false);
  });

  test(
    'isNewLine should properly declare whether int represents new line or carriage return',
    () {
      expect(0x0A.isNewLine, true);
      expect(0x0D.isNewLine, true);
      expect(0x0C.isNewLine, false);
      expect(0x20.isNewLine, false);
      expect(0x21.isNewLine, false);
    },
  );

  test(
    'isWhitespace should properly declare whether int represents whitespace',
    () {
      expect(0x20.isWhitespace, true);
      expect(0x09.isWhitespace, true);
      expect(0x0A.isWhitespace, true);
      expect(0x0D.isWhitespace, true);
      expect(0x21.isWhitespace, false);
      expect(0x0C.isWhitespace, false);
    },
  );

  group('inRange()', () {
    test('should return false if int is in fact null', () {
      expect(null.inRange(0, 1000), false);
    });

    test('should return true if int is within provided range inclusive', () {
      expect(20.inRange(0, 30), true);
      expect(20.inRange(20, 20), true);
      expect(20.inRange(20, 20, inclusive: true), true);
      expect(10.inRange(10, 20, inclusive: true), true);
      expect(10.inRange(0, 10, inclusive: true), true);
    });

    test('should return true if int is within provided range exclusive', () {
      expect(20.inRange(0, 30, inclusive: false), true);
      expect(21.inRange(20, 22, inclusive: false), true);
      expect(11.inRange(10, 20, inclusive: false), true);
      expect(5.inRange(0, 10, inclusive: false), true);
    });

    test(
      'should return false if int is not within provided range inclusive',
      () {
        expect((-1).inRange(0, 30), false);
        expect(30.inRange(20, 20), false);
        expect(21.inRange(20, 20, inclusive: true), false);
        expect(9.inRange(10, 20, inclusive: true), false);
        expect(11.inRange(0, 10, inclusive: true), false);
      },
    );

    test(
      'should return false if int is not within provided range exclusive',
      () {
        expect(30.inRange(0, 30, inclusive: false), false);
        expect(0.inRange(20, 22, inclusive: false), false);
        expect(10.inRange(10, 20, inclusive: false), false);
        expect(10.inRange(0, 10, inclusive: false), false);
      },
    );
  });
}
