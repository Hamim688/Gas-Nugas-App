import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  // --- FUNGSI DAFTAR AKUN KE FIREBASE ---
  Future<void> daftarAkun() async {
    // 1. Cek ada yang kosong nggak
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kotak wajib diisi coy!")),
      );
      return;
    }

    // 2. Cek password sama konfirmasi password cocok nggak
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Yah passwordnya beda, cek lagi ya Shayankkuhh!"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 3. Suruh satpam Firebase bikinin KTP baru
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 4. Kalau sukses, tutup halaman ini.
      // (Nanti main.dart bakal otomatis nyadar lu udah login, dan langsung nendang lu ke Dashboard!)
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal daftar: ${e.message}")));
    } finally {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.app_registration_rounded,
                    size: 80,
                    color: Color(0xFF09637E),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Bikin Akun Baru",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Biar tugas lu nggak kecampur orang lain",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 50),

                Text(
                  "Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Contoh: hamim@email.com",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  "Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Masukkan password (min. 6 huruf/angka)",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  "Konfirmasi Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Ketik ulang password lu",
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF09637E),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: daftarAkun,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF09637E),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Udah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        // Kalau berubah pikiran, balik ke halaman login
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login di sini",
                        style: TextStyle(
                          color: Color(0xFF147efb),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
