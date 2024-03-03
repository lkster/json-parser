import 'package:json_parser/core/utils/char_code.dart';

extension IntChar on int? {
  bool get isSpace => this == CharCode.space.code;

  bool get isTab => this == CharCode.tab.code;

  bool get isNewLine =>
      [CharCode.lineFeed.code, CharCode.carriageReturn.code].contains(this);

  bool get isWhitespace => isSpace || isTab || isNewLine;

  bool inRange(int start, int end, {bool inclusive = true}) {
    if (this == null) {
      return false;
    }

    if (inclusive) {
      return this! >= start && this! <= end;
    }

    return this! > start && this! < end;
  }
}
