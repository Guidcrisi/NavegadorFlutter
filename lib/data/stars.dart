import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Stars {
  static Future<File> getStars() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/stars.json");
  }

  static Future<File> saveStars(stars) async {
    String data = json.encode(stars);
    final file = await getStars();
    return file.writeAsString(data);
  }

  static Future<String> readStars() async {
    try {
      final file = await getStars();
      return file.readAsString();
    } catch (e) {
      return "null";
    }
  }
}
