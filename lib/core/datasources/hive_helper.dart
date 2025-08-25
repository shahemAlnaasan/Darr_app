import 'dart:developer';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveHelper {
  static Future<void> storeInHive({required String boxName, required String key, required dynamic value}) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.put(key, value);
      log("Storing in Hive was successful for $key → $value");
    } catch (e) {
      log("Error storing in Hive: $e");
    }
  }

  static Future<dynamic> getFromHive({required String boxName, required String key}) async {
    try {
      final box = await Hive.openBox(boxName);
      return box.get(key);
    } catch (e) {
      log("Error retrieving from Hive: $e");
      return null;
    }
  }

  Future<void> deleteFromHive({required String boxName, required String key}) async {
    try {
      final box = await Hive.openBox(boxName);
      if (box.containsKey(key)) {
        await box.delete(key);
        log("Deleted key: $key from box: $boxName");
      } else {
        log("Key: $key not found in box: $boxName");
      }
    } catch (e) {
      log("Error deleting from Hive: $e");
    }
  }
}
