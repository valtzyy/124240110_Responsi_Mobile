import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/favorite.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   // pastikan perangkat siap
  await Hive.initFlutter();                    // inisialisasi Hive
  Hive.registerAdapter(FavoriteAdapter());     // daftarkan adapter
  await Hive.openBox<Favorite>('favorites');   // buka box
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoginScreen(),               // WAJIB diisi, kalau tidak layar blank
    );
  }
}