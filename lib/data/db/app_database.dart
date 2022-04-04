import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class AppDatabase {
  // the only available instance of this AppDatabase class
  // is stored in this private field.
  static final AppDatabase _singleton = AppDatabase._();

  // this instance get only property is the only way for other classes to access
  // the sinlge AppDatabase object.
  static AppDatabase get instance => _singleton;

  Completer<Database>? _dbOpenCompleter;

  // if a class specifies its own constructior, it immediatelly loses the default one.
  // This means that by providing a private constructor we can create new instances
  // only from within this AppDatabase db class.
  AppDatabase._(); // private constructor

  Future<Database> get database async {
    // if null, the db is not yet open.
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      // calling _openDatabase will also complete the completer with db instance.
      _openDatabase();
    }
    // if the db is already open, return immediatelly.
    // Otherwise, wait until complete() is called on the Completer in _openDatabase().
    return _dbOpenCompleter!.future; // never null by the time we're here?
  }

  Future _openDatabase() async {
    final appDocmentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocmentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  }
}
