import 'package:json_parser/core/lexer/scanner.dart';
import 'package:json_parser/core/utils/int_extension.dart';
import 'package:test/test.dart';

void main() {
  test('isDone should return whether scanner reached end of source', () {
    final scanner = Scanner('abc');

    expect(scanner.isDone, false);

    scanner.readChar();
    scanner.readChar();

    expect(scanner.isDone, false);

    scanner.readChar();

    expect(scanner.isDone, true);
  });

  group('readChar()', () {
    late Scanner scanner;

    setUp(() {
      scanner = Scanner('abc123');
    });

    test('should return next char', () {
      expect(String.fromCharCode(scanner.readChar()), 'a');
      expect(String.fromCharCode(scanner.readChar()), 'b');
      expect(String.fromCharCode(scanner.readChar()), 'c');
      expect(String.fromCharCode(scanner.readChar()), '1');
      expect(String.fromCharCode(scanner.readChar()), '2');
      expect(String.fromCharCode(scanner.readChar()), '3');
    });

    test('should increment position', () {
      expect(scanner.position, 0);
      scanner.readChar();
      expect(scanner.position, 1);
      scanner.readChar();
      expect(scanner.position, 2);
      scanner.readChar();
      expect(scanner.position, 3);
      scanner.readChar();
      expect(scanner.position, 4);
      scanner.readChar();
      expect(scanner.position, 5);
      scanner.readChar();
      expect(scanner.position, 6);
    });
  });

  group('peekChar()', () {
    late Scanner scanner;

    setUp(() {
      scanner = Scanner('abc123');
    });

    test('should return char based on provided offset', () {
      expect(String.fromCharCode(scanner.peekChar()!), 'a');
      expect(String.fromCharCode(scanner.peekChar(0)!), 'a');
      expect(String.fromCharCode(scanner.peekChar(1)!), 'b');
      expect(String.fromCharCode(scanner.peekChar(5)!), '3');

      scanner.readChar();
      scanner.readChar();

      expect(String.fromCharCode(scanner.peekChar()!), 'c');
      expect(String.fromCharCode(scanner.peekChar(1)!), '1');
      expect(String.fromCharCode(scanner.peekChar(3)!), '3');
    });

    test('should return null if offset is out of bounds', () {
      expect(scanner.peekChar(10), null);

      scanner.readChar();
      scanner.readChar();
      scanner.readChar();
      scanner.readChar();
      scanner.readChar();
      scanner.readChar();

      expect(scanner.peekChar(), null);
    });

    test('should not change position', () {
      scanner.peekChar();
      scanner.peekChar();

      expect(scanner.position, 0);

      scanner.readChar();
      scanner.readChar();

      scanner.peekChar(2);

      expect(scanner.position, 2);
    });
  });

  group('expectString()', () {
    test("should return true if string matches on current cursor's position", () {
      var scanner = Scanner('matchtestlol');

      expect(scanner.expectString('match'), true);

      scanner = Scanner('matchtestlol');

      scanner..readChar()..readChar()..readChar()..readChar()..readChar();

      expect(scanner.expectString('test'), true);
    });

    test("should properly set cursor's position", () {
      var scanner = Scanner('matchtestlol');

      scanner.expectString('match');

      expect(scanner.position, 5);

      scanner = Scanner('matchtestlol');

      scanner..readChar()..readChar()..readChar()..readChar()..readChar();

      scanner.expectString('test');

      expect(scanner.position, 9);
    });

    test('should return false if provided string does not match', () {
      var scanner = Scanner('matchtestlol');

      expect(scanner.expectString('watch'), false);
      expect(scanner.expectString('atch'), false);
    });

    test("should not move cursor forward if there was no match", () {
      var scanner = Scanner('matchtestlol');

      scanner.expectString('atch');

      expect(scanner.position, 0);
    });
  });

  test('omitWhitespace() should omit all whitespace characters', () {
    final scanner = Scanner('   abc  \n\t\t123');

    expect(scanner.peekChar().isWhitespace, true);

    scanner.omitWhitespace();

    expect(scanner.readChar().isWhitespace, false);

    scanner.readChar();
    scanner.readChar();

    scanner.omitWhitespace();

    expect(scanner.readChar().isWhitespace, false);
  });

  group('readNonWhitespace()', () {
    late Scanner scanner;

    setUp(() {
      scanner = Scanner('   \n\n\tabc');
    });

    test('should return first non-whitespace character', () {
      expect(scanner.readNonWhitespace().isWhitespace, false);
    });

    test('should forward position', () {
      scanner.readNonWhitespace();

      expect(scanner.position, 7);
    });
  });

  group('peekNonWhitespace()', () {
    late Scanner scanner;

    setUp(() {
      scanner = Scanner('   \n\n\tabc');
    });

    test('should return first non-whitespace character', () {
      expect(scanner.peekNonWhitespace().isWhitespace, false);
    });

    test('should not forward position', () {
      scanner.peekNonWhitespace();

      expect(scanner.position, 0);
    });
  });
}
