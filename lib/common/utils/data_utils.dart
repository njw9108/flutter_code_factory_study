import 'package:code_factory/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrl(List<String> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
