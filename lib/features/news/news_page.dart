import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/breakpoints.dart';
import '../../core/widgets/app_sidebar.dart';
import 'news_controller.dart';
import 'news_model.dart';

const kNavy = Color(0xFF1A2744);
const kGold = Color(0xFFC4922A);
const kWarmBg = Color(0xFFF5F3EE);

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NewsController());
    // نستخدم ResponsiveLayout مباشرة بدل AppScaffold لتجنب تعارض Obx
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        if (isDesktop) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F3EE),
            body: Row(
              children: [
                AppSidebar(currentIndex: 1),
                const Expanded(child: _NewsBody()),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF5F3EE),
          body: const _NewsBody(),
          bottomNavigationBar: _BottomNav(),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _NewsBody — Column عادي بدون Slivers لتجنب مشكلة Obx داخل CustomScrollView
// ════════════════════════════════════════════════════════════════════════════════
class _NewsBody extends StatelessWidget {
  const _NewsBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NewsController>();
    final isDesktop = Breakpoints.isDesktop(context);

    return Column(
      children: [
        // ── Header ────────────────────────────────────────────────────────
        if (isDesktop)
          _DesktopHeader(ctrl: ctrl)
        else
          _MobileAppBar(ctrl: ctrl),

        // ── الفئات ────────────────────────────────────────────────────────
        _CategoriesBar(isDesktop: isDesktop),

        // ── المحتوى المتمرر ───────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            final filtered = ctrl.filteredNews;
            final featured = ctrl.featuredNews;

            return RefreshIndicator(
              color: kGold,
              onRefresh: ctrl.refresh,
              child: ListView(
                children: [
                  // خبر مميز
                  if (featured != null)
                    _FeaturedCard(news: featured, isDesktop: isDesktop),

                  // رأس القسم
                  _SectionHeader(isDesktop: isDesktop),

                  // القائمة
                  if (filtered.isEmpty)
                    const _EmptyState()
                  else if (isDesktop)
                    _DesktopGrid(news: filtered)
                  else
                    _MobileList(news: filtered),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Mobile AppBar ─────────────────────────────────────────────────────────────
class _MobileAppBar extends StatelessWidget {
  final NewsController ctrl;
  const _MobileAppBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavy,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.menu, color: Colors.white),
              const Spacer(),
              Text(
                'الأخبار',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.notifications_outlined, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          _SearchField(ctrl: ctrl, onNavy: true),
        ],
      ),
    );
  }
}

// ── Desktop Header ────────────────────────────────────────────────────────────
class _DesktopHeader extends StatelessWidget {
  final NewsController ctrl;
  const _DesktopHeader({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            'الأخبار',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kNavy,
            ),
          ),
          const Spacer(),
          SizedBox(width: 260, child: _SearchField(ctrl: ctrl, onNavy: false)),
        ],
      ),
    );
  }
}

// ── Search Field ──────────────────────────────────────────────────────────────
class _SearchField extends StatelessWidget {
  final NewsController ctrl;
  final bool onNavy;
  const _SearchField({required this.ctrl, required this.onNavy});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: onNavy ? Colors.white.withOpacity(0.12) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: onNavy
            ? null
            : Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        onChanged: (v) => ctrl.search(v),
        style: GoogleFonts.cairo(
          color: onNavy ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث في الأخبار...',
          hintStyle: GoogleFonts.cairo(
            color: onNavy ? Colors.white54 : Colors.grey,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: onNavy ? Colors.white54 : Colors.grey,
            size: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
        ),
      ),
    );
  }
}

// ── Categories Bar — Obx خارج ListView تماماً ────────────────────────────────
class _CategoriesBar extends StatelessWidget {
  final bool isDesktop;
  const _CategoriesBar({required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NewsController>();
    return Obx(() {
      final selected = ctrl.selectedCategory.value;
      return Container(
        color: kWarmBg,
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 20 : 10,
          vertical: 8,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ctrl.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {
            final cat = ctrl.categories[i];
            final isActive = selected == cat;
            return GestureDetector(
              onTap: () => ctrl.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isActive ? kNavy : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? kNavy : const Color(0xFFD0CDC5),
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: isActive ? Colors.white : const Color(0xFF6B6860),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

// ── Featured Card ─────────────────────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final NewsModel news;
  final bool isDesktop;
  const _FeaturedCard({required this.news, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final hPad = isDesktop ? 20.0 : 12.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Get.toNamed('/news/${news.id}'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Container(
                  height: isDesktop ? 260 : 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kNavy, Color(0xFF2D4A7A), kGold],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      news.imageEmoji,
                      style: TextStyle(fontSize: isDesktop ? 72 : 56),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: kGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'مميز',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          news.title,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        if (news.summary.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            news.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          '${news.date} • ${news.source}',
                          style: GoogleFonts.cairo(
                            color: Colors.white60,
                            fontSize: 11,
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
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final bool isDesktop;
  const _SectionHeader({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 20 : 12,
        16,
        isDesktop ? 20 : 12,
        8,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: kGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'آخر الأخبار',
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Desktop Grid ──────────────────────────────────────────────────────────────
class _DesktopGrid extends StatelessWidget {
  final List<NewsModel> news;
  const _DesktopGrid({required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemCount: news.length,
        itemBuilder: (_, i) => _NewsCard(news: news[i], isDesktop: true),
      ),
    );
  }
}

// ── Mobile List ───────────────────────────────────────────────────────────────
class _MobileList extends StatelessWidget {
  final List<NewsModel> news;
  const _MobileList({required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: news
          .map(
            (n) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: _NewsCard(news: n, isDesktop: false),
            ),
          )
          .toList(),
    );
  }
}

// ── News Card ─────────────────────────────────────────────────────────────────
class _NewsCard extends StatefulWidget {
  final NewsModel news;
  final bool isDesktop;
  const _NewsCard({required this.news, required this.isDesktop});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _hovered = false;

  static const _thumbColors = [
    Color(0xFFE8EEF7),
    Color(0xFFEEF7E8),
    Color(0xFFF7F0E8),
    Color(0xFFF0E8F7),
  ];

  @override
  Widget build(BuildContext context) {
    final thumbColor = _thumbColors[widget.news.id % _thumbColors.length];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.toNamed('/news/${widget.news.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFFB8B5AF)
                  : const Color(0xFFE8E5DF),
              width: 0.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.news.category,
                        style: GoogleFonts.cairo(fontSize: 10, color: kNavy),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: widget.isDesktop ? 13 : 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1916),
                        height: 1.45,
                      ),
                    ),
                    if (widget.news.summary.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.news.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          widget.news.date,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: const Color(0xFF9B9890),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCCCCCC),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.news.source,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: const Color(0xFF9B9890),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: thumbColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.news.imageEmoji,
                    style: const TextStyle(fontSize: 28),
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

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Text('🔍', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'لا توجد أخبار في هذا التصنيف',
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav (Mobile) ───────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (i) {
        const routes = ['/', '/news', '/events', '/engineer'];
        if (i < routes.length) Get.toNamed(routes[i]);
      },
      backgroundColor: Colors.white,
      selectedItemColor: kNavy,
      unselectedItemColor: const Color(0xFF9B9890),
      selectedLabelStyle: GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.cairo(fontSize: 10),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper_outlined),
          label: 'الأخبار',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          label: 'الفعاليات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'حسابي',
        ),
      ],
    );
  }
}
