import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final prefs = GetStorage();

  static Future<void> initalizeStorage() async {
    await GetStorage.init();
  }

  static void setLocalParameter(String key, String? value) {
    prefs.write(key, value);
  }

  static String? getLocalParameter(String key) {
    return prefs.read(key);
  }
}
