import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(context),
            const SizedBox(height: 40),
            _buildNewsSection(context),
            const SizedBox(height: 40),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER — متجاوب بالكامل
  // ---------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/logo.png", height: 45),
                        const SizedBox(width: 10),
                        Text(
                          "نقابة المهندسين - فرع دمشق",
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // زر القائمة للموبايل
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _navItem("الرئيسية", '/'),
                                _navItem("خدماتنا", '/services'),
                                _navItem("الأخبار", '/news'),
                                _navItem("الأنشطة", '/events'),
                                _navItem("المكاتب", '/offices'),
                                _navItem("صفحة المهندس", '/engineer'),
                                _navItem("الأنظمة والقوانين", '/about'),
                                _navItem("اتصل بنا", '/contact'),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Get.toNamed('/login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                  ),
                                  child: Text(
                                    "تسجيل الدخول",
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/logo.png", height: 60),
                    const SizedBox(width: 10),
                    Text(
                      "نقابة المهندسين - فرع دمشق",
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    _navItem("الرئيسية", '/'),
                    _navItem("خدماتنا", '/services'),
                    _navItem("الأخبار", '/news'),
                    _navItem("الأنشطة", '/events'),
                    _navItem("المكاتب", '/offices'),
                    _navItem("صفحة المهندس", '/engineer'),
                    _navItem("الأنظمة والقوانين", '/about'),
                    _navItem("اتصل بنا", '/contact'),
                  ],
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    "تسجيل الدخول",
                    style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _navItem(String title, String route) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // HERO SECTION — متجاوب
  // ---------------------------------------------------------
  Widget _buildHeroSection(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.45;
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: height,
      width: double.infinity,
      color: Colors.black87, // خلفية تظهر فورًا قبل تحميل الصورة
      child: Stack(
        fit: StackFit.expand,
        children: [
          // صورة محسّنة + تحميل صحيح على الموبايل
          CachedNetworkImage(
            imageUrl:
                "https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?w=1200",
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: Colors.black38), // لا تظهر سوداء بالكامل
            errorWidget: (context, url, error) =>
                Container(color: Colors.black54),
          ),

          // طبقة التعتيم
          Container(color: Colors.black.withOpacity(0.45)),

          // النصوص
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "مرحباً بكم في نقابة المهندسين - فرع دمشق",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "خدمات هندسية – أخبار – معاملات – المكاتب",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: isMobile ? 14 : 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/engineer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    "صفحة المهندس",
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.white,
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

  // ---------------------------------------------------------
  // NEWS SECTION — متجاوب
  // ---------------------------------------------------------
  Widget _buildNewsSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "آخر الأخبار",
          style: GoogleFonts.cairo(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _newsCard(context),
            _newsCard(context),
            _newsCard(context),
          ],
        ),
      ],
    );
  }

  Widget _newsCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth < 400 ? screenWidth * 0.9 : 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              "https://images.unsplash.com/photo-1503387762-592deb58ef4e",
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "افتتاح مركز خدمات هندسية جديد في دمشق",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // FOOTER — متجاوب
  // ---------------------------------------------------------
  Widget _buildFooter(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      color: const Color(0xFF0D1B2A),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 60,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "عن النقابة",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "نقابة المهندسين - فرع دمشق هي جهة مهنية تعنى بتنظيم مهنة الهندسة ورعاية شؤون المهندسين وتقديم الخدمات الهندسية والمهنية والمجتمعية.",
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تواصل معنا",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "دمشق - اتستراد المزة - بناء نقابة المهندسين - مقابل مشفى الرازي",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "011-6619410",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "https://www.facebook.com/profile.php?id=100064370152076",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "© 2026 نقابة مهندسي فرع دمشق. جميع الحقوق محفوظة.",
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }
}
