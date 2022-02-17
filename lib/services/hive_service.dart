import 'package:hive/hive.dart';

class HiveDB{
  static String DB_NAME = "flutter_B14";
  static var box = Hive.box(DB_NAME);

  static void storeMode(bool isLight) async{
    box.put("mode", isLight);
  }

  static bool loadMode(){
    return box.get("mode", defaultValue: true);
  }

  static void storeLang(String lang) async{
    box.put("lang", lang);
  }

  static String loadLang(){
    return box.get("lang", defaultValue: "EN");
  }
}