import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../news/news_model.dart';
import '../news/news_repository.dart';
import '../../core/services/auth_service.dart';

// ── ألوان ──────────────────────────────────────────────────────────────────────
const kNavy = Color(0xFF1A2744);
const kNavy2 = Color(0xFF243258);
const kGold = Color(0xFFC4922A);
const kGoldLt = Color(0xFFF5E6C8);
const kWarmBg = Color(0xFFF5F3EE);
const kRed = Color(0xFFD93025);
const kRedLt = Color(0xFFFCE8E6);
const kGreen = Color(0xFF1E7E34);
const kGreenLt = Color(0xFFE6F4EA);

// ════════════════════════════════════════════════════════════════════════════════
// AdminNewsController
// ════════════════════════════════════════════════════════════════════════════════
class AdminNewsController extends GetxController {
  final NewsRepository repo = Get.find<NewsRepository>();

  String searchQuery = '';
  String filterCategory = 'الكل';

  final categories = ['الكل', 'إعلانات', 'فعاليات', 'قرارات', 'مناقصات'];

  final emojiOptions = [
    '📰',
    '📋',
    '🏗️',
    '🏆',
    '📢',
    '💼',
    '🔧',
    '📌',
    '🎯',
    '🏛️',
    '⚙️',
    '📊',
  ];

  List<NewsModel> get filteredNews {
    var list = repo.news.toList();
    if (filterCategory != 'الكل') {
      list = list.where((n) => n.category == filterCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      list = list
          .where(
            (n) =>
                n.title.contains(searchQuery) ||
                n.summary.contains(searchQuery),
          )
          .toList();
    }
    return list;
  }

  void search(String q) {
    searchQuery = q;
    update();
  }

  void setCategory(String c) {
    filterCategory = c;
    update();
  }

  Future<void> deleteNews(String firestoreId) async {
    await repo.deleteNews(firestoreId);
    update();
  }

  void addNews(NewsModel item) {
    repo.addNews(item);
    update();
  }

  void updateNews(NewsModel item) {
    repo.updateNews(item);
    update();
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// AdminNewsPage
// ════════════════════════════════════════════════════════════════════════════════
class AdminNewsPage extends StatelessWidget {
  const AdminNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminNewsController());
    return Scaffold(
      backgroundColor: kWarmBg,
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────────────────────────────
          _AdminSidebar(),
          // ── Main content ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _AdminTopBar(ctrl: ctrl),
                Expanded(
                  child: GetBuilder<AdminNewsController>(
                    builder: (ctrl) => _NewsTable(ctrl: ctrl),
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

// ════════════════════════════════════════════════════════════════════════════════
// Sidebar
// ════════════════════════════════════════════════════════════════════════════════
class _AdminSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: kNavy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
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
          _sideLink(
            Icons.dashboard_outlined,
            'الرئيسية',
            false,
            () => Get.toNamed('/'),
          ),
          _sideLink(Icons.newspaper_outlined, 'إدارة الأخبار', true, () {}),
          _sideLink(
            Icons.event_outlined,
            'الفعاليات',
            false,
            () => Get.toNamed('/events'),
          ),
          _sideLink(Icons.people_outline, 'الأعضاء', false, () {}),
          _sideLink(Icons.settings_outlined, 'الإعدادات', false, () {}),
          const Spacer(),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _sideLink(
              Icons.arrow_back_outlined,
              'العودة للموقع',
              false,
              () => Get.toNamed('/news'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sideLink(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return _SidebarTile(icon: icon, label: label, active: active, onTap: onTap);
  }
}

class _SidebarTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final bg = widget.active
        ? kGold.withOpacity(0.18)
        : _hovered
        ? Colors.white.withOpacity(0.06)
        : Colors.transparent;
    final fg = widget.active ? const Color(0xFFE8C87A) : Colors.white70;
    return MouseRegion(
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

// ════════════════════════════════════════════════════════════════════════════════
// Top Bar
// ════════════════════════════════════════════════════════════════════════════════
class _AdminTopBar extends StatelessWidget {
  final AdminNewsController ctrl;
  const _AdminTopBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // العنوان والعداد
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة الأخبار',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                ),
              ),
              GetBuilder<AdminNewsController>(
                builder: (c) => Text(
                  '${c.repo.news.length} خبر في قاعدة البيانات',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // بحث
          SizedBox(
            width: 220,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: TextField(
                textDirection: TextDirection.rtl,
                onChanged: (v) {
                  ctrl.search(v);
                },
                style: GoogleFonts.cairo(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'ابحث...',
                  hintStyle: GoogleFonts.cairo(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // زر إضافة
          ElevatedButton.icon(
            onPressed: () => _showNewsDialog(context, ctrl),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'إضافة خبر',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// جدول الأخبار
// ════════════════════════════════════════════════════════════════════════════════
class _NewsTable extends StatelessWidget {
  final AdminNewsController ctrl;
  const _NewsTable({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final news = ctrl.filteredNews;

    return Column(
      children: [
        // فلتر الفئات
        _CategoryFilter(ctrl: ctrl),
        // الجدول
        Expanded(
          child: news.isEmpty
              ? _EmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // رأس الجدول
                      _TableHeader(),
                      const SizedBox(height: 4),
                      // الصفوف
                      ...news.map(
                        (item) =>
                            _NewsRow(news: item, ctrl: ctrl, context: context),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

// ── فلتر الفئات ───────────────────────────────────────────────────────────────
class _CategoryFilter extends StatelessWidget {
  final AdminNewsController ctrl;
  const _CategoryFilter({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            'فلترة:',
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 10),
          ...ctrl.categories.map((cat) {
            final isActive = ctrl.filterCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: GestureDetector(
                onTap: () => ctrl.setCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? kNavy : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? kNavy : Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: isActive ? Colors.white : Colors.grey.shade700,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── رأس الجدول ────────────────────────────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _hCell('الإيموجي', 60),
          _hCell('العنوان', 0, flex: true),
          _hCell('الفئة', 90),
          _hCell('التاريخ', 100),
          _hCell('المصدر', 100),
          _hCell('مميز', 60),
          _hCell('الإجراءات', 100),
        ],
      ),
    );
  }

  Widget _hCell(String label, double width, {bool flex = false}) {
    final child = Text(
      label,
      style: GoogleFonts.cairo(
        color: Colors.white70,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
    return flex ? Expanded(child: child) : SizedBox(width: width, child: child);
  }
}

// ── صف الخبر ─────────────────────────────────────────────────────────────────
class _NewsRow extends StatefulWidget {
  final NewsModel news;
  final AdminNewsController ctrl;
  final BuildContext context;
  const _NewsRow({
    required this.news,
    required this.ctrl,
    required this.context,
  });
  @override
  State<_NewsRow> createState() => _NewsRowState();
}

class _NewsRowState extends State<_NewsRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.news;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFF0EDE8) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered ? const Color(0xFFD0CBC3) : const Color(0xFFEAE7E2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // إيموجي
            SizedBox(
              width: 60,
              child: Text(n.imageEmoji, style: const TextStyle(fontSize: 22)),
            ),
            // العنوان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1916),
                    ),
                  ),
                  if (n.summary.isNotEmpty)
                    Text(
                      n.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            // الفئة
            SizedBox(
              width: 90,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _categoryColor(n.category).$2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  n.category,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: _categoryColor(n.category).$1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // التاريخ
            SizedBox(
              width: 100,
              child: Text(
                n.date,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            // المصدر
            SizedBox(
              width: 100,
              child: Text(
                n.source,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            // مميز
            SizedBox(
              width: 60,
              child: n.isFeatured
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: kGoldLt,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'مميز',
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: kGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            // الإجراءات
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  // تعديل
                  _ActionBtn(
                    icon: Icons.edit_outlined,
                    color: kNavy,
                    tooltip: 'تعديل',
                    onTap: () =>
                        _showNewsDialog(context, widget.ctrl, existing: n),
                  ),
                  const SizedBox(width: 6),
                  // حذف
                  _ActionBtn(
                    icon: Icons.delete_outline,
                    color: kRed,
                    tooltip: 'حذف',
                    onTap: () => _confirmDelete(context, widget.ctrl, n),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _categoryColor(String cat) {
    return switch (cat) {
      'إعلانات' => (const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
      'فعاليات' => (const Color(0xFF2E7D32), const Color(0xFFE8F5E9)),
      'قرارات' => (const Color(0xFF6A1B9A), const Color(0xFFF3E5F5)),
      'مناقصات' => (const Color(0xFFE65100), const Color(0xFFFFF3E0)),
      _ => (kNavy, const Color(0xFFE8EEF7)),
    };
  }
}

// ── زر إجراء ─────────────────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });
  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withOpacity(0.12)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 0.5),
            ),
            child: Icon(
              widget.icon,
              color: _hovered ? widget.color : Colors.grey.shade500,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ── حالة فارغة ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'لا توجد أخبار',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اضغط "إضافة خبر" لإضافة أول خبر',
            style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// Dialog — إضافة / تعديل خبر
// ════════════════════════════════════════════════════════════════════════════════
void _showNewsDialog(
  BuildContext context,
  AdminNewsController ctrl, {
  NewsModel? existing,
}) {
  final isEdit = existing != null;

  // Controllers النصية
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final summaryCtrl = TextEditingController(text: existing?.summary ?? '');
  final sourceCtrl = TextEditingController(
    text: existing?.source ?? 'نقابة دمشق',
  );
  final dateCtrl = TextEditingController(text: existing?.date ?? _todayAr());

  // State داخل الـ Dialog
  String selectedCat = existing?.category ?? 'إعلانات';
  String selectedEmoji = existing?.imageEmoji ?? '📰';
  bool isFeatured = existing?.isFeatured ?? false;
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (ctx, setState) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ─────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: kNavy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
                      color: kGold,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isEdit ? 'تعديل الخبر' : 'إضافة خبر جديد',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Form ───────────────────────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        _formLabel('عنوان الخبر *'),
                        _formField(
                          controller: titleCtrl,
                          hint: 'أدخل عنوان الخبر...',
                          validator: (v) =>
                              v!.trim().isEmpty ? 'العنوان مطلوب' : null,
                        ),
                        const SizedBox(height: 14),

                        // الملخص
                        _formLabel('الملخص'),
                        _formField(
                          controller: summaryCtrl,
                          hint: 'ملخص مختصر للخبر...',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),

                        // الفئة والإيموجي في صف واحد
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _formLabel('الفئة *'),
                                  _DropdownField(
                                    value: selectedCat,
                                    items: [
                                      'إعلانات',
                                      'فعاليات',
                                      'قرارات',
                                      'مناقصات',
                                    ],
                                    onChanged: (v) =>
                                        setState(() => selectedCat = v!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _formLabel('الأيقونة'),
                                  _EmojiPicker(
                                    selected: selectedEmoji,
                                    options: ctrl.emojiOptions,
                                    onSelect: (e) =>
                                        setState(() => selectedEmoji = e),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // المصدر والتاريخ في صف واحد
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _formLabel('المصدر'),
                                  _formField(
                                    controller: sourceCtrl,
                                    hint: 'نقابة دمشق',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _formLabel('التاريخ'),
                                  _formField(
                                    controller: dateCtrl,
                                    hint: 'مثال: ١٥ يناير ٢٠٢٥',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // خبر مميز
                        GestureDetector(
                          onTap: () => setState(() => isFeatured = !isFeatured),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isFeatured ? kGoldLt : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isFeatured
                                    ? kGold
                                    : Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isFeatured ? Icons.star : Icons.star_border,
                                  color: isFeatured ? kGold : Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'خبر مميز (يظهر في أعلى الصفحة)',
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    color: isFeatured
                                        ? const Color(0xFF8B6200)
                                        : Colors.grey.shade700,
                                  ),
                                ),
                                const Spacer(),
                                if (isFeatured)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kGold,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'مفعّل',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Footer ─────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    // زر إلغاء
                    OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: GoogleFonts.cairo(fontSize: 13),
                      ),
                    ),
                    const Spacer(),
                    // زر حفظ
                    ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        final item = NewsModel(
                          id: existing?.id ?? 0,
                          title: titleCtrl.text.trim(),
                          summary: summaryCtrl.text.trim(),
                          category: selectedCat,
                          date: dateCtrl.text.trim().isEmpty
                              ? _todayAr()
                              : dateCtrl.text.trim(),
                          source: sourceCtrl.text.trim().isEmpty
                              ? 'نقابة دمشق'
                              : sourceCtrl.text.trim(),
                          isFeatured: isFeatured,
                          imageEmoji: selectedEmoji,
                          firestoreId: existing?.firestoreId,
                        );

                        if (isEdit) {
                          ctrl.updateNews(item);
                        } else {
                          ctrl.addNews(item);
                        }

                        Navigator.of(ctx).pop();

                        // رسالة نجاح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit
                                  ? '✅ تم تعديل الخبر بنجاح'
                                  : '✅ تم إضافة الخبر بنجاح',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: kGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        isEdit ? Icons.save_outlined : Icons.add,
                        size: 18,
                      ),
                      label: Text(
                        isEdit ? 'حفظ التعديلات' : 'إضافة الخبر',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNavy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════════
// Dialog — تأكيد الحذف
// ════════════════════════════════════════════════════════════════════════════════
void _confirmDelete(
  BuildContext context,
  AdminNewsController ctrl,
  NewsModel news,
) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: kRedLt,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: kRed, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'حذف الخبر',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1916),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'هل أنت متأكد من حذف الخبر؟\n"${news.title}"',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'لا يمكن التراجع عن هذا الإجراء',
                style: GoogleFonts.cairo(fontSize: 11, color: kRed),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: GoogleFonts.cairo(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ctrl.deleteNews(news.firestoreId ?? news.id.toString());
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🗑️ تم حذف الخبر',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: kRed,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'حذف',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════════
// Widgets مساعدة للـ Form
// ════════════════════════════════════════════════════════════════════════════════
Widget _formLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      label,
      style: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF444240),
      ),
    ),
  );
}

Widget _formField({
  required TextEditingController controller,
  required String hint,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    textDirection: TextDirection.rtl,
    validator: validator,
    style: GoogleFonts.cairo(fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kNavy, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kRed, width: 0.5),
      ),
    ),
  );
}

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: GoogleFonts.cairo(fontSize: 13)),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kNavy, width: 1),
        ),
      ),
    );
  }
}

class _EmojiPicker extends StatelessWidget {
  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelect;
  const _EmojiPicker({
    required this.selected,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: options.map((e) {
          final isSelected = e == selected;
          return GestureDetector(
            onTap: () => onSelect(e),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? kNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(e, style: const TextStyle(fontSize: 16)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── تاريخ اليوم بالعربي ───────────────────────────────────────────────────────
String _todayAr() {
  final now = DateTime.now();
  const months = [
    '',
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return '${now.day} ${months[now.month]} ${now.year}';
}
