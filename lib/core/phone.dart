/// Iraqi mobile numbers only; normalize Arabic/Persian digits before validating.
String normalizeDigits(String value) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  return value.split('').map((c) {
    final a = arabic.indexOf(c);
    final p = persian.indexOf(c);
    return a >= 0
        ? '$a'
        : p >= 0
        ? '$p'
        : c;
  }).join();
}

String? iraqiPhone(String input) {
  var n = normalizeDigits(input).replaceAll(RegExp(r'[\s()\-]'), '');
  if (n.startsWith('00')) n = '+${n.substring(2)}';
  if (RegExp(r'^07[0-9]{9}$').hasMatch(n)) n = '+964${n.substring(1)}';
  if (RegExp(r'^7[0-9]{9}$').hasMatch(n)) n = '+964$n';
  if (RegExp(r'^9647[0-9]{9}$').hasMatch(n)) n = '+$n';
  return RegExp(r'^\+9647[0-9]{9}$').hasMatch(n) ? n : null;
}
