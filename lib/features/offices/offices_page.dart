import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfficesPage extends StatelessWidget {
  const OfficesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final offices = [
      {"name": "نظام العمل"},
      {"name": "التعرفة"},
      {"name": "دليل المكاتب الهندسية"},
      {"name": "دليل المكاتب الاستشارية"},
      {"name": "قرارات صادرة عن لجنة المكاتب الهندسية"},
      {"name": "الأسئلة المتكررة"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("المكاتب الهندسية", style: GoogleFonts.cairo()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: offices.length,
        itemBuilder: (context, index) {
          final office = offices[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.apartment, color: Colors.blue),
              title: Text(
                office["name"]!,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(
              //   "${office["address"]}\nهاتف: ${office["phone"]}",
              //   style: GoogleFonts.cairo(),
              //  ),
              isThreeLine: false,
            ),
          );
        },
      ),
    );
  }
}
