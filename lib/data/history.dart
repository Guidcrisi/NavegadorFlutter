import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class History {
  static Future<File> getHistory() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/history.json");
  }

  static Future<File> saveHistory(history) async {
    String data = json.encode(history);
    final file = await getHistory();
    return file.writeAsString(data);
  }

  static Future<String> readHistory() async {
    try {
      final file = await getHistory();
      return file.readAsString();
    } catch (e) {
      return "null";
    }
  }
}
