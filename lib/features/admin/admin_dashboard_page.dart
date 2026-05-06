import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';

const kNavy = Color(0xFF1A2744);
const kGold = Color(0xFFC4922A);
const kWarmBg = Color(0xFFF5F3EE);

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    final items = [
      _DashItem(
        icon: Icons.newspaper_outlined,
        label: 'إدارة الأخبار',
        description: 'إضافة وتعديل وحذف الأخبار',
        color: const Color(0xFF1565C0),
        bgColor: const Color(0xFFE3F2FD),
        route: '/admin/news',
      ),
      _DashItem(
        icon: Icons.build_outlined,
        label: 'إدارة الخدمات',
        description: 'تعديل خدمات النقابة',
        color: const Color(0xFF2E7D32),
        bgColor: const Color(0xFFE8F5E9),
        route: '/admin/services',
      ),
      _DashItem(
        icon: Icons.people_outline,
        label: 'إدارة المهندسين',
        description: 'بيانات وتراخيص الأعضاء',
        color: const Color(0xFF6A1B9A),
        bgColor: const Color(0xFFF3E5F5),
        route: '/admin/engineers',
      ),
      _DashItem(
        icon: Icons.settings_outlined,
        label: 'إعدادات الموقع',
        description: 'إعدادات عامة للموقع',
        color: const Color(0xFFE65100),
        bgColor: const Color(0xFFFFF3E0),
        route: '/admin/settings',
      ),
    ];

    return Scaffold(
      backgroundColor: kWarmBg,
      body: Row(
        children: [
          // ── Sidebar ──────────────────────────────────────────────────────
          _AdminSidebar(auth: auth),

          // ── المحتوى ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لوحة التحكم',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: kNavy,
                            ),
                          ),
                          Text(
                            'مرحباً، أنت مسجّل كمدير',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // زر العودة للموقع
                      OutlinedButton.icon(
                        onPressed: () => Get.toNamed('/'),
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          size: 16,
                        ),
                        label: Text(
                          'العودة للموقع',
                          style: GoogleFonts.cairo(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kNavy,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الأقسام',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.6,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                              ),
                          itemCount: items.length,
                          itemBuilder: (_, i) => _DashCard(item: items[i]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── بطاقة القسم ──────────────────────────────────────────────────────────────
class _DashCard extends StatefulWidget {
  final _DashItem item;
  const _DashCard({required this.item, super.key});

  @override
  State<_DashCard> createState() => _DashCardState();
}

class _DashCardState extends State<_DashCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.toNamed(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? widget.item.color.withOpacity(0.4)
                  : const Color(0xFFEAE7E2),
              width: 0.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.item.color.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // أيقونة
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: widget.item.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.item.icon,
                  color: widget.item.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // نص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item.label,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1916),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.item.description,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // سهم
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 14,
                  color: _hovered ? widget.item.color : Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sidebar الإدارة ───────────────────────────────────────────────────────────
class _AdminSidebar extends StatelessWidget {
  final AuthService auth;
  const _AdminSidebar({required this.auth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: kNavy,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.engineering,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'لوحة الإدارة',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 8),
          _link(Icons.dashboard_outlined, 'الرئيسية', true, () {}),
          _link(
            Icons.newspaper_outlined,
            'إدارة الأخبار',
            false,
            () => Get.toNamed('/admin/news'),
          ),
          _link(Icons.build_outlined, 'الخدمات', false, () {}),
          _link(Icons.people_outline, 'المهندسون', false, () {}),
          _link(Icons.settings_outlined, 'الإعدادات', false, () {}),
          const Spacer(),
          const Divider(color: Colors.white12, height: 1),
          _link(
            Icons.arrow_forward_outlined,
            'العودة للموقع',
            false,
            () => Get.toNamed('/'),
          ),
          _link(
            Icons.logout,
            'تسجيل الخروج',
            false,
            () => auth.logout(),
            isLogout: true,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _link(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return _SideLink(
      icon: icon,
      label: label,
      active: active,
      onTap: onTap,
      isLogout: isLogout,
    );
  }
}

class _SideLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool isLogout;
  final VoidCallback onTap;
  const _SideLink({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.isLogout = false,
  });
  @override
  State<_SideLink> createState() => _SideLinkState();
}

class _SideLinkState extends State<_SideLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final fg = widget.isLogout
        ? (_hovered ? const Color(0xFFFF6B6B) : Colors.white38)
        : widget.active
        ? const Color(0xFFE8C87A)
        : Colors.white70;
    final bg = widget.isLogout
        ? (_hovered
              ? const Color(0xFFD93025).withOpacity(0.15)
              : Colors.transparent)
        : widget.active
        ? kGold.withOpacity(0.18)
        : (_hovered ? Colors.white.withOpacity(0.06) : Colors.transparent);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: widget.active
                ? Border.all(color: kGold.withOpacity(0.3), width: 0.5)
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: fg, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.cairo(
                  color: fg,
                  fontSize: 13,
                  fontWeight: widget.active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Model ─────────────────────────────────────────────────────────────────────
class _DashItem {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final Color bgColor;
  final String route;

  const _DashItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.bgColor,
    required this.route,
  });
}
