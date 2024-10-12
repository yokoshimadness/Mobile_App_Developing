abstract class LocalStorage {
  Future<void> saveData(String key, String value);
  Future<String?> getData(String key);
  Future<void> deleteData(String key);
  Future<void> saveTransactions(List<Map<String, String>> transactions);
  Future<List<Map<String, String>>> getTransactions();
}
