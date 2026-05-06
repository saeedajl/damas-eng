import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_scaffold.dart';

const kNavy = Color(0xFF1A2744);
const kNavy2 = Color(0xFF243258);
const kGold = Color(0xFFC4922A);
const kGoldLt = Color(0xFFF5E6C8);
const kWarmBg = Color(0xFFF5F3EE);

// ════════════════════════════════════════════════════════════════════════════════
// Model
// ════════════════════════════════════════════════════════════════════════════════
class ServiceModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<String> features;

  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.features,
  });
}

// ════════════════════════════════════════════════════════════════════════════════
// Data
// ════════════════════════════════════════════════════════════════════════════════
const List<ServiceModel> kServices = [
  ServiceModel(
    title: 'صندوق الضمان الصحي',
    description:
        'يوفر الصندوق تغطية صحية شاملة لأعضاء النقابة وذويهم، بما يشمل الرعاية الطبية والعلاجية في أفضل المستشفيات والمراكز الصحية.',
    icon: Icons.health_and_safety_outlined,
    color: Color(0xFF1565C0),
    bgColor: Color(0xFFE3F2FD),
    features: [
      'تغطية طبية كاملة',
      'شبكة مستشفيات واسعة',
      'تغطية لأفراد الأسرة',
      'خدمة طوارئ 24/7',
    ],
  ),
  ServiceModel(
    title: 'صندوق التكافل',
    description:
        'صندوق تضامني يهدف إلى مساندة الأعضاء في الأوقات الصعبة، ويقدم دعماً مالياً في حالات الحوادث والأزمات الطارئة.',
    icon: Icons.people_outline,
    color: Color(0xFF2E7D32),
    bgColor: Color(0xFFE8F5E9),
    features: [
      'دعم مالي طارئ',
      'مساعدات عينية',
      'دعم حالات الحوادث',
      'إجراءات سريعة',
    ],
  ),
  ServiceModel(
    title: 'صندوق إعانة الوفاة والشيخوخة',
    description:
        'يضمن الصندوق حقوق المهندسين وذويهم في حالات الوفاة، ويقدم مساعدات مالية للأعضاء المسنين الذين أمضوا سنوات في خدمة المهنة.',
    icon: Icons.elderly_outlined,
    color: Color(0xFF6A1B9A),
    bgColor: Color(0xFFF3E5F5),
    features: [
      'إعانة وفاة للأسرة',
      'مساعدات للمسنين',
      'تسوية سريعة للمطالبات',
      'دعم مستمر',
    ],
  ),
  ServiceModel(
    title: 'خزانة التقاعد',
    description:
        'توفر خزانة التقاعد مدخرات منتظمة للمهندسين تضمن لهم دخلاً ثابتاً بعد انتهاء مسيرتهم المهنية، وتحافظ على مستوى معيشتهم.',
    icon: Icons.savings_outlined,
    color: Color(0xFFE65100),
    bgColor: Color(0xFFFFF3E0),
    features: [
      'مدخرات شهرية منتظمة',
      'عوائد مضمونة',
      'مرونة في الاشتراك',
      'دفعات تقاعد منتظمة',
    ],
  ),
  ServiceModel(
    title: 'التأمين الصحي',
    description:
        'برنامج تأميني متكامل يغطي النفقات الصحية للمهندسين المشتركين، مع إمكانية الاختيار من بين باقات تأمينية متعددة تناسب احتياجات كل عضو.',
    icon: Icons.medical_services_outlined,
    color: Color(0xFF00695C),
    bgColor: Color(0xFFE0F2F1),
    features: [
      'باقات متعددة',
      'تغطية أسنان وبصريات',
      'أدوية بتكلفة مخفضة',
      'تأمين سفر',
    ],
  ),
  ServiceModel(
    title: 'نشاطات اجتماعية',
    description:
        'تنظم النقابة طيفاً واسعاً من الفعاليات والأنشطة الاجتماعية والثقافية والرياضية التي تعزز الروابط بين أعضاء الجسم الهندسي.',
    icon: Icons.celebration_outlined,
    color: Color(0xFFC62828),
    bgColor: Color(0xFFFFEBEE),
    features: [
      'رحلات سياحية',
      'بطولات رياضية',
      'أمسيات ثقافية',
      'احتفاليات التكريم',
    ],
  ),
];

// ════════════════════════════════════════════════════════════════════════════════
// ServicesPage
// ════════════════════════════════════════════════════════════════════════════════
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الخدمات',
      currentIndex: 2,
      body: _ServicesBody(),
    );
  }
}

class _ServicesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: kGold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'خدماتنا',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'تقدم نقابة المهندسين فرع دمشق مجموعة من الخدمات لأعضائها',
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            isDesktop ? _DesktopGrid() : _MobileList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Header Banner ─────────────────────────────────────────────────────────────

// ── Desktop Grid (2 columns) ──────────────────────────────────────────────────
class _DesktopGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: kServices.length,
      itemBuilder: (_, i) => _ServiceCard(service: kServices[i]),
    );
  }
}

// ── Mobile List ───────────────────────────────────────────────────────────────
class _MobileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: kServices
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ServiceCard(service: s),
            ),
          )
          .toList(),
    );
  }
}

// ── Service Card ──────────────────────────────────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  const _ServiceCard({required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? s.color.withOpacity(0.4)
                  : const Color(0xFFEAE7E2),
              width: _hovered ? 1 : 0.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: s.color.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة والعنوان
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: s.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title,
                          style: GoogleFonts.cairo(
                            fontSize: isDesktop ? 15 : 14,
                            fontWeight: FontWeight.w700,
                            color: kNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.description,
                          maxLines: isDesktop ? 2 : (_expanded ? 10 : 2),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // سهم
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _hovered ? s.color : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ],
              ),

              // المميزات (تظهر عند التوسع)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: s.features
                          .map(
                            (f) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: s.bgColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: s.color.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: s.color,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    f,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: s.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    // زر اعرف أكثر
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _showServiceDialog(context, widget.service),
                        icon: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: s.color,
                        ),
                        label: Text(
                          'تفاصيل الخدمة',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: s.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: s.color.withOpacity(0.4),
                            width: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
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
// Dialog تفاصيل الخدمة
// ════════════════════════════════════════════════════════════════════════════════
void _showServiceDialog(BuildContext context, ServiceModel s) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: s.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      s.title,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.description,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'مميزات الخدمة',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...s.features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: s.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            f,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // زر التواصل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.toNamed('/contact');
                      },
                      icon: const Icon(Icons.mail_outline, size: 16),
                      label: Text(
                        'تواصل معنا للاستفسار',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: s.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
