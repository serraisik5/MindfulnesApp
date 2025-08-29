import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final prefs = GetStorage();

  static Future<void> initalizeStorage() async {
    await GetStorage.init();
  }

  // Generic setter
  static void setLocalParameter<T>(String key, T value) {
    prefs.write(key, value);
  }

  // Generic getter with optional default
  static T? getLocalParameter<T>(String key, {T? defaultValue}) {
    return prefs.read<T>(key) ?? defaultValue;
  }

  // Optional helper to remove
  static void removeParameter(String key) {
    prefs.remove(key);
  }
}
