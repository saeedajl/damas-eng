import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class EngineerLoginPage extends StatelessWidget {
  const EngineerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerNumber = TextEditingController();
    final controllerPassword = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "صفحة المهندس",
                style: GoogleFonts.cairo(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "تسجيل الدخول لاستعراض المعاملات والبيانات المالية",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),

              // رقم نقابي
              Align(
                alignment: Alignment.centerRight,
                child: Text("الرقم النقابي", style: GoogleFonts.cairo()),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: controllerNumber,
                decoration: InputDecoration(
                  hintText: "أدخل رقمك النقابي",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // كلمة المرور
              Align(
                alignment: Alignment.centerRight,
                child: Text("كلمة المرور", style: GoogleFonts.cairo()),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: controllerPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "أدخل كلمة المرور",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: GoogleFonts.cairo(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "تسجيل الدخول",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Get.toNamed('/'),
                child: Text(
                  "العودة للموقع الرئيسي →",
                  style: GoogleFonts.cairo(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
