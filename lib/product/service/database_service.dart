import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  DatabaseService._private();
  static final DatabaseService _instance = DatabaseService._private();
  static DatabaseService get instance => _instance;

  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    instance.database = await Hive.openBox<String>('offline_database');
  }

  late final Box<String> database;
}
