import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_layout.dart';
import 'app_sidebar.dart';

const kNavy   = Color(0xFF1A2744);
const kGold   = Color(0xFFC4922A);
const kWarmBg = Color(0xFFF5F3EE);

/// Scaffold موحّد لكل صفحات التطبيق.
/// يتبدّل تلقائياً بين BottomNav (موبايل) و Drawer (تابلت) و Sidebar (حاسب).
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final List<Widget>? actions;

  const AppScaffold({required this.body, required this.title, this.currentIndex = 0, this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile:  _MobileScaffold(s: this),
      tablet:  _TabletScaffold(s: this),
      desktop: _DesktopScaffold(s: this),
    );
  }
}

class _MobileScaffold extends StatelessWidget {
  final AppScaffold s;
  const _MobileScaffold({required this.s});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kWarmBg,
    body: s.body,
    bottomNavigationBar: _BottomNav(currentIndex: s.currentIndex),
  );
}

class _TabletScaffold extends StatelessWidget {
  final AppScaffold s;
  const _TabletScaffold({required this.s});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kWarmBg,
    drawer: Drawer(width: 220, child: AppSidebar(currentIndex: s.currentIndex)),
    appBar: AppBar(
      backgroundColor: kNavy,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(s.title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16)),
      actions: s.actions,
    ),
    body: s.body,
  );
}

class _DesktopScaffold extends StatelessWidget {
  final AppScaffold s;
  const _DesktopScaffold({required this.s});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kWarmBg,
    body: Row(children: [
      AppSidebar(currentIndex: s.currentIndex),
      Expanded(child: s.body),
    ]),
  );
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  static const _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined),           label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.newspaper_outlined),      label: 'الأخبار'),
    BottomNavigationBarItem(icon: Icon(Icons.event_outlined),          label: 'الفعاليات'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'حسابي'),
  ];
  static const _routes = ['/', '/news', '/events', '/engineer'];

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
    currentIndex: currentIndex.clamp(0, _items.length - 1),
    onTap: (i) => Get.toNamed(_routes[i]),
    backgroundColor: Colors.white,
    selectedItemColor: kNavy,
    unselectedItemColor: const Color(0xFF9B9890),
    selectedLabelStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
    unselectedLabelStyle: GoogleFonts.cairo(fontSize: 10),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    items: _items,
  );
}
