import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'news_model.dart';

class NewsRepository extends GetxService {
  static NewsRepository get to => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'news';

  final RxList<NewsModel> news = <NewsModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // الاستماع للتغييرات في Firestore بشكل real-time
    _listenToNews();
  }

  // ── Real-time listener ────────────────────────────────────────────────────
  void _listenToNews() {
    _db
        .collection(_collection)
        .orderBy('id', descending: false)
        .snapshots()
        .listen((snapshot) {
      news.value = snapshot.docs
          .map((doc) => NewsModel.fromJson(
                doc.data(),
                firestoreId: doc.id,
              ))
          .toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
    });
  }

  // ── إضافة خبر ─────────────────────────────────────────────────────────────
  Future<void> addNews(NewsModel item) async {
    try {
      // احسب أعلى id موجود وأضف 1
      final newId = news.isEmpty
          ? 1
          : news.map((n) => n.id).reduce((a, b) => a > b ? a : b) + 1;

      final newItem = item.copyWith(id: newId);

      // إذا كان مميزاً → أزل التمييز عن الباقين أولاً
      if (newItem.isFeatured) await _clearFeatured();

      await _db.collection(_collection).add(newItem.toJson());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة الخبر: $e');
    }
  }

  // ── تعديل خبر ─────────────────────────────────────────────────────────────
  Future<void> updateNews(NewsModel updated) async {
    if (updated.firestoreId == null) return;
    try {
      // إذا كان مميزاً → أزل التمييز عن الباقين
      if (updated.isFeatured) await _clearFeatured(excludeId: updated.firestoreId);

      await _db
          .collection(_collection)
          .doc(updated.firestoreId)
          .update(updated.toJson());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تعديل الخبر: $e');
    }
  }

  // ── حذف خبر ───────────────────────────────────────────────────────────────
  Future<void> deleteNews(String firestoreId) async {
    try {
      await _db.collection(_collection).doc(firestoreId).delete();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل حذف الخبر: $e');
    }
  }

  // ── إزالة التمييز عن كل الأخبار ──────────────────────────────────────────
  Future<void> _clearFeatured({String? excludeId}) async {
    final batch = _db.batch();
    final featured = await _db
        .collection(_collection)
        .where('isFeatured', isEqualTo: true)
        .get();

    for (final doc in featured.docs) {
      if (doc.id != excludeId) {
        batch.update(doc.reference, {'isFeatured': false});
      }
    }
    await batch.commit();
  }

  // ── Getters ───────────────────────────────────────────────────────────────
  List<NewsModel> get featuredList => news.where((n) => n.isFeatured).toList();
  List<NewsModel> get regularList  => news.where((n) => !n.isFeatured).toList();
}
