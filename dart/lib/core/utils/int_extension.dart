import 'package:json_parser/core/utils/char_code.dart';

extension IntChar on int? {
  bool get isSpace => this == $space;

  bool get isTab => this == $tab;

  bool get isNewLine =>
      [$lineFeed, $carriageReturn].contains(this);

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
