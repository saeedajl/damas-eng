import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'admin_login_dialog.dart';

const kNavy = Color(0xFF1A2744);
const kGold  = Color(0xFFC4922A);

class AppSidebar extends StatefulWidget {
  final int currentIndex;
  const AppSidebar({required this.currentIndex, super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  int get currentIndex => widget.currentIndex;

  @override
  void initState() {
    super.initState();
    // استمع لتغييرات isAdmin وأعد البناء
    Get.find<AuthService>().isAdmin.listen((_) {
      if (mounted) setState(() {});
    });
  }

  static const _items = [
    _NavItem(icon: Icons.home_outlined,          label: 'الرئيسية',   route: '/'),
    _NavItem(icon: Icons.newspaper_outlined,     label: 'الأخبار',    route: '/news'),
    _NavItem(icon: Icons.build_outlined,         label: 'الخدمات',    route: '/services'),
    _NavItem(icon: Icons.event_outlined,         label: 'الفعاليات',  route: '/events'),
    _NavItem(icon: Icons.business_outlined,      label: 'المكاتب',    route: '/offices'),
    _NavItem(icon: Icons.info_outline,           label: 'من نحن',     route: '/about'),
    _NavItem(icon: Icons.mail_outline,           label: 'تواصل معنا', route: '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    return Container(
      width: 220,
      color: kNavy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.engineering,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'نقابة المهندسين\nفرع دمشق',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                ),
              ]),
            ),
          ),

          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 8),

          // ── روابط التنقل ──────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _items.length,
              itemBuilder: (_, i) => _SidebarTile(
                item: _items[i],
                isActive: i == widget.currentIndex,
                onTap: () => Get.toNamed(_items[i].route),
              ),
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // ── زر الإدارة ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: auth.isAdmin.value
                // المدير مسجّل دخوله
                ? Column(children: [
                    _SidebarTile(
                      item: const _NavItem(
                        icon: Icons.admin_panel_settings_outlined,
                        label: 'لوحة الإدارة',
                        route: '/admin/news',
                      ),
                      isActive: false,
                      highlight: true,
                      onTap: () => Get.toNamed('/admin/news'),
                    ),
                    _SidebarTile(
                      item: const _NavItem(
                        icon: Icons.logout,
                        label: 'تسجيل الخروج',
                        route: '',
                      ),
                      isActive: false,
                      isLogout: true,
                      onTap: () => auth.logout(),
                    ),
                  ])
                // زر دخول الإدارة
                : _SidebarTile(
                    item: const _NavItem(
                      icon: Icons.lock_outline,
                      label: 'دخول الإدارة',
                      route: '',
                    ),
                    isActive: false,
                    isAdmin: true,
                    onTap: () => showAdminLoginDialog(context),
                  ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// SidebarTile مع Hover
// ════════════════════════════════════════════════════════════════════════════════
class _SidebarTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final bool highlight;
  final bool isAdmin;
  final bool isLogout;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.highlight = false,
    this.isAdmin   = false,
    this.isLogout  = false,
  });

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // ألوان حسب نوع الزر
    Color bg, fg;

    if (widget.isLogout) {
      bg = _hovered
          ? const Color(0xFFD93025).withOpacity(0.15)
          : Colors.transparent;
      fg = _hovered
          ? const Color(0xFFFF6B6B)
          : Colors.white38;
    } else if (widget.isAdmin) {
      bg = _hovered
          ? kGold.withOpacity(0.15)
          : kGold.withOpacity(0.08);
      fg = const Color(0xFFE8C87A);
    } else if (widget.highlight) {
      bg = _hovered
          ? kGold.withOpacity(0.22)
          : kGold.withOpacity(0.15);
      fg = const Color(0xFFE8C87A);
    } else if (widget.isActive) {
      bg = kGold.withOpacity(0.18);
      fg = const Color(0xFFE8C87A);
    } else {
      bg = _hovered ? Colors.white.withOpacity(0.06) : Colors.transparent;
      fg = Colors.white70;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: (widget.isActive || widget.highlight || widget.isAdmin)
                ? Border.all(color: kGold.withOpacity(0.25), width: 0.5)
                : null,
          ),
          child: Row(children: [
            Icon(widget.item.icon, color: fg, size: 18),
            const SizedBox(width: 10),
            Text(
              widget.item.label,
              style: GoogleFonts.cairo(
                color: fg,
                fontSize: 13,
                fontWeight: (widget.isActive || widget.isAdmin || widget.highlight)
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
            // نقطة مميزة لزر الإدارة
            if (widget.isAdmin) ...[
              const Spacer(),
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: kGold,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.label, required this.route});
}
