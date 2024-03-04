/// It could be done with simple map to have easier access (`CharCode.space` instead of `CharCode.space.code`)
/// or even with just exported consts like `charcode` package has (`$space`) but I wanted to group it in one entity and
/// use Dart's enum features
enum CharCode {
  space(0x20),
  tab(0x09),
  lineFeed(0x0A),
  carriageReturn(0x0D),
  dot(0x2E),
  openBracket(0x5B),
  closeBracket(0x5D),
  openBrace(0x7B),
  closeBrace(0x7D),
  doubleQuote(0x22),
  comma(0x2C),
  colon(0x3A),
  num0(0x30),
  num1(0x31),
  num2(0x32),
  num3(0x33),
  num4(0x34),
  num5(0x35),
  num6(0x36),
  num7(0x37),
  num8(0x38),
  num9(0x39);

  const CharCode(this.code);

  final int code;
}
