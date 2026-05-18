import 'dart:convert';

class Encrypt {
  static String encode(String value) {
    return base64Url.encode(utf8.encode(value));
  }

  static String decode(String value) {
    return utf8.decode(base64Url.decode(value));
  }
}
