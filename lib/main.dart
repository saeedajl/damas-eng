import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'features/home/home_page.dart';
import 'features/news/news_page.dart';
import 'features/news/news_repository.dart';
import 'features/services/services_page.dart';
import 'features/events/events_page.dart';
import 'features/offices/offices_page.dart';
import 'features/engineer/engineer_login_page.dart';
import 'features/about/about_page.dart';
import 'features/contact/contact_page.dart';
import 'features/auth/login_page.dart';
import 'features/admin/admin_dashboard_page.dart';
import 'features/admin/admin_news_page.dart';
import 'core/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تسجيل الخدمات
  await Get.putAsync<AuthService>(
      () async => AuthService(), permanent: true);
  await Get.putAsync<NewsRepository>(
      () async => NewsRepository(), permanent: true);

  runApp(const DamasEngApp());
}

class DamasEngApp extends StatelessWidget {
  const DamasEngApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'نقابة المهندسين - فرع دمشق',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
            textDirection: TextDirection.rtl, child: child!);
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.cairoTextTheme(),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/',           page: () => const HomePage()),
        GetPage(name: '/news',       page: () => const NewsPage()),
        GetPage(name: '/services',   page: () => const ServicesPage()),
        GetPage(name: '/events',     page: () => const EventsPage()),
        GetPage(name: '/offices',    page: () => const OfficesPage()),
        GetPage(name: '/engineer',   page: () => const EngineerLoginPage()),
        GetPage(name: '/about',      page: () => const AboutPage()),
        GetPage(name: '/contact',    page: () => const ContactPage()),
        GetPage(name: '/login',      page: () => const LoginPage()),
        GetPage(name: '/admin',      page: () => const AdminDashboardPage()),
        GetPage(name: '/admin/news', page: () => const AdminNewsPage()),
      ],
    );
  }
}
