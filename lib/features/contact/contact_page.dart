import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerName = TextEditingController();
    final controllerEmail = TextEditingController();
    final controllerMessage = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("اتصل بنا", style: GoogleFonts.cairo()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(labelText: "الاسم"),
            ),
            TextField(
              controller: controllerEmail,
              decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            TextField(
              controller: controllerMessage,
              decoration: const InputDecoration(labelText: "الرسالة"),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // هنا لاحقاً ترسل الرسالة للسيرفر
              },
              child: Text("إرسال", style: GoogleFonts.cairo()),
            )
          ],
        ),
      ),
    );
  }
}
