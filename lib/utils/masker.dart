class Masker {
  Masker(this.text, [this.start = 4, this.end = 4]);

  final String text;
  final int start;
  final int end;

  String get mask {
    try {
      return text.isNotEmpty && text.length >= (start + end)
          ? '${text.substring(0, start)}...${text.substring(text.length - end, text.length)}'
          : text;
    } catch (_) {
      return text;
    }
  }
}
