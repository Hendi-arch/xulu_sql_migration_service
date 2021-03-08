import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPreferencesService {
  static SharedPreferencesService _instance;

  static Future<SharedPreferencesService> getInstance({bool enableLogs = false}) async {
    if (_instance == null) {
      _instance = SharedPreferencesService._(FlutterSecureStorage(), enableLogs);
    }

    return _instance;
  }

  final enableLogs;
  final FlutterSecureStorage _preferences;
  SharedPreferencesService._(
    this._preferences,
    this.enableLogs,
  );

  static const _DefaultDatabaseVersionKey = 'database_version_key';
  String _databaseVersionKey;

  String get databaseVersionKey => _databaseVersionKey ?? _DefaultDatabaseVersionKey;

  set databaseVersionKey(String key) => _databaseVersionKey = key;

  int get databaseVersion => _getFromDisk(databaseVersionKey) ?? 0;

  set databaseVersion(int value) => _saveToDisk(databaseVersionKey, value);

  void clearPreferences() {
    _preferences.deleteAll();
  }

  dynamic _getFromDisk(String key) async {
    var value = await _preferences.read(key: key);
    if (enableLogs) print('key:$key value:$value');
    return value;
  }

  void _saveToDisk(String key, dynamic content) {
    if (enableLogs) print('key:$key value:$content');

    _preferences.write(key: key, value: content);
  }
}
