import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الأنشطة والفعاليات", style: GoogleFonts.cairo()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.blue),
              title: Text(
                "فعالية رقم ${index + 1}",
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "تفاصيل مختصرة عن الفعالية رقم ${index + 1}",
                style: GoogleFonts.cairo(),
              ),
            ),
          );
        },
      ),
    );
  }
}
