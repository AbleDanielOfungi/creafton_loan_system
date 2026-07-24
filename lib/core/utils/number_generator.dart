class NumberGenerator {
  static String loanNumber() {
    final now = DateTime.now();

    return "LN-${now.year}${now.month.toString().padLeft(2, '0')}${now.microsecond}";
  }

  static String borrowerNumber() {
    final now = DateTime.now();

    return "BR-${now.year}${now.microsecond}";
  }
}
