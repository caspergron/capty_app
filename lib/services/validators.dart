import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/public/country.dart';
import 'package:app/utils/reg_exps.dart';

class Validators {
  String? name(String data) {
    if (data.isEmpty) return 'please_write_your_name'.recast;
    return null;
  }

  String? fullName(String data) {
    if (data.isEmpty) return 'please_write_your_name'.recast;
    final words = data.trim().split(RegExp(r'\s+'));
    if (words.length < 2) return 'you_must_write_your_full_name'.recast;
    return null;
  }

  String? email(String data) {
    if (data.isEmpty) return 'please_write_your_email_address'.recast;
    if (!sl<RegExps>().email.hasMatch(data)) return 'please_write_a_valid_email_address'.recast;
    return null;
  }

  String? phone(String data, Country country) {
    if (data.isEmpty) return 'please_write_your_phone_number'.recast;
    final isValid = data.length >= (country.minLength ?? 10) && data.length <= (country.maxLength ?? 10);
    if (!isValid) return '${'phone_number_must_be_at_least'.recast} ${country.minLength ?? 10} ${'digit'.recast}';
    return null;
  }

  String? otpCode(String data) {
    if (data.isEmpty) return 'please_enter_your_verification_code'.recast;
    if (data.length != 4) return 'verification_code_must_be_4_digit'.recast;
    return null;
  }

  String? address(String data) {
    if (data.isEmpty) return 'please_write_your_address'.recast;
    return null;
  }

  String? validateSocialLink(String data) {
    const message1 = 'please_write_the_social_link_link_of_your_club';
    const message2 = 'please_write_a_valid_url_for_your_club';
    if (data.isEmpty) return message1.recast;
    if (!sl<RegExps>().urlRegExp.hasMatch(data)) return message2.recast;
    return null;
  }

  String? validateUrl(String data, String label) {
    final message1 = 'please_write_the_${label}_link_of_your_club';
    final message2 = 'please_write_a_valid_url_for_$label';
    if (data.isEmpty) return message1.recast;
    if (!sl<RegExps>().urlRegExp.hasMatch(data)) return message2.recast;
    return null;
  }
}
