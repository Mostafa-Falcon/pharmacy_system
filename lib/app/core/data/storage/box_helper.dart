/// @deprecated Hive box helper stub.
/// The sync engine refactor removed Hive dependencies.
/// Use DAOs directly instead of BoxHelper.
abstract final class BoxHelper {
  static T get<T>(String name) => throw UnsupportedError('BoxHelper.get is deprecated — use DAOs');

  static Future<T> open<T>(String name) async => throw UnsupportedError('BoxHelper.open is deprecated — use DAOs');

  static Box getDynamic(String name) => throw UnsupportedError('BoxHelper.getDynamic is deprecated — use DAOs');

  static Future<Box> openDynamic(String name) async => throw UnsupportedError('BoxHelper.openDynamic is deprecated — use DAOs');
}

typedef Box = Map<String, dynamic>;
