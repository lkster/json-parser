import 'package:json_parser/json_parser.dart';
import 'package:test/test.dart';

void main() {
  test('should properly parse number', () {
    expect(parseJson('1234'), 1234);
    expect(parseJson('12.54'), 12.54);
  });

  test('should properly parse boolean', () {
    expect(parseJson('true'), true);
    expect(parseJson('false'), false);
  });

  test('should properly parse null', () {
    expect(parseJson('null'), null);
  });

  test('should properly parse string', () {
    expect(parseJson('"some string"'), 'some string');
    expect(parseJson('"some \\n \\" \\t\\tstring"'), 'some \n " \t\tstring');
  });

  test('should properly parse arrays', () {
    expect(parseJson('[]'), []);
    expect(
      parseJson('["some string", 23.21, false]'),
      [
        'some string',
        23.21,
        false,
      ],
    );
    expect(parseJson('[[true, [false]]]'), [[true, [false]]]);
  });
}
