import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final getStorage = GetStorage();

  bool hasLocalData({required String key}) => getStorage.hasData(key);

  dynamic readData({required String key}) => getStorage.read(key);

  Future<void> storeData({required String key, required value}) => getStorage.write(key, value);

  Future<void> removeData({required String key}) => getStorage.remove(key);

  Future<void> removeAllData() => getStorage.erase();
}
