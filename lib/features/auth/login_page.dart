import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerUser = TextEditingController();
    final controllerPass = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل الدخول", style: GoogleFonts.cairo()),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("تسجيل الدخول", style: GoogleFonts.cairo(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controllerUser,
                    decoration: const InputDecoration(labelText: "اسم المستخدم"),
                  ),
                  TextField(
                    controller: controllerPass,
                    decoration: const InputDecoration(labelText: "كلمة المرور"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // تحقق وهمي
                      Get.offNamed('/admin');
                    },
                    child: Text("دخول", style: GoogleFonts.cairo()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
