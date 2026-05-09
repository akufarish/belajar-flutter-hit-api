import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hit_api/providers/user_provider.dart';
import 'package:hit_api/screens/tambah_user_screen.dart';
import 'package:hit_api/screens/user_home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/tambah-user": (context) => TambahUserScreen(),
        "/": (context) => UserHomeScreen(),
      },
    );
  }
}
