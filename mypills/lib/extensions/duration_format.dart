class DurationFormat {
  static String formatHMS(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  static String formatHM(Duration d) {
    final tmp = d.toString();
    return tmp.substring(0, tmp.lastIndexOf(':'));
  }
  static String formatMS(Duration d) {
    final tmp = d.toString();
    return tmp.substring(tmp.indexOf(':') + 1, tmp.lastIndexOf('.'));
  }

}