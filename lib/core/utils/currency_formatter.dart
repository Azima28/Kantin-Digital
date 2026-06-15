class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a double value to Indonesian Rupiah representation (e.g. 15000.0 -> "Rp 15.000")
  static String format(double value) {
    final int val = value.round();
    final String str = val.toString();
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final String formatted = str.replaceAllMapped(reg, (Match match) => '${match[1]}.');
    return 'Rp $formatted';
  }
}
