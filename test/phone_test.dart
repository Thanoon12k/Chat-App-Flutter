import 'package:chatapp/core/phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes Iraqi mobile formats and Arabic numerals', () {
    for (final value in [
      '07701234567',
      '+9647701234567',
      '009647701234567',
      '7701234567',
      '٠٧٧٠١٢٣٤٥٦٧',
      '۰۷۷۰۱۲۳۴۵۶۷',
      '0770 123-4567',
    ]) {
      expect(iraqiPhone(value), '+9647701234567');
    }
  });
  test('rejects foreign, malformed and landline numbers', () {
    for (final value in [
      '+15551234567',
      '0770123456',
      '077012345678',
      '+9641770123456',
      'abc07701234567',
      '',
    ]) {
      expect(iraqiPhone(value), isNull);
    }
  });
}
