import 'dart:convert';

import 'package:crypto/crypto.dart';

class Encryption {
  String generateMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }
}