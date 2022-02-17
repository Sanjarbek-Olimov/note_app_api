import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app_api/pages/notes_page.dart';
import 'package:note_app_api/services/hive_service.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('uz', 'UZ'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
     return ValueListenableBuilder(
         valueListenable: HiveDB.box.listenable(),
         builder: (BuildContext context, box, Widget? child) {
           return MaterialApp(
             localizationsDelegates: context.localizationDelegates,
             supportedLocales: context.supportedLocales,
             locale: context.locale,
             debugShowCheckedModeBanner: false,
             themeMode: HiveDB.loadMode() ? ThemeMode.light: ThemeMode.dark,
             darkTheme: ThemeData.dark(),
             theme: ThemeData.light(),
             title: 'Flutter Demo',
             home: const NotesPage(),
             routes: {
               NotesPage.id: (context) => const NotesPage()
             },
           );
         },
     );
  }
}

