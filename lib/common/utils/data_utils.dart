import 'dart:convert';

import 'package:code_factory/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrl(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }

  static DateTime stringToDateTime(String? value) {
    if (value == null) {
      print('value is null');
    }
    return value == null ? DateTime.now() : DateTime.parse(value);
  }
}
