import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth's PUT /user accepts channel; the Dart UserAttributes constructor does
/// not expose it. Preserve SDK session handling while adding that API field.
class PhoneAttributes extends UserAttributes {
  final OtpChannel channel;
  PhoneAttributes({required String phone, required this.channel})
    : super(phone: phone);
  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'channel': channel.name};
}
