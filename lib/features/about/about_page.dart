import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      "القانون 23 تاريخ 26-6-2005",
      "المرسوم 80 للعام 2010",
      "نظام مزاولة المهنة",
      "نظام صندوق الضمان الصحي",
      "نظام التدريب و التأهيل",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("القوانين والانظمة", style: GoogleFonts.cairo()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.engineering),
              title: Text(
                services[index],
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
