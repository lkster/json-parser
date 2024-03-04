import 'package:json_parser/json_parser.dart';
import 'package:test/test.dart';

void main() {
  test('should properly parse number', () {
    expect(parseJson('1234'), 1234);
    expect(parseJson('12.54'), 12.54);
  });
}