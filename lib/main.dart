import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proect_gas_nugas/pages/dashboard.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proect_gas_nugas/pages/login_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        // CCTV mantau status login
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Menunggu cek koneksi Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Kalau User udah login
          if (snapshot.hasData) {
            return MyDashboard();
          }

          // Kalau belum login / udah logout
          return LoginPage();
        },
      ),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}