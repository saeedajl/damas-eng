import 'package:get/get.dart';
import 'news_model.dart';
import 'news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repo = Get.find<NewsRepository>();

  // Rx variables
  final RxString selectedCategory = 'الكل'.obs;
  final RxString searchQuery = ''.obs;

  final categories = ['الكل', 'إعلانات', 'فعاليات', 'قرارات', 'مناقصات'];

  @override
  void onInit() {
    super.onInit();
    // إذا كان repo.news RxList، يكفي أن نراقبه بدون update()
    ever(_repo.news, (_) {});
  }

  List<NewsModel> get filteredNews {
    var list = _repo.regularList;

    if (selectedCategory.value != 'الكل') {
      list = list
          .where((n) => n.category.trim() == selectedCategory.value.trim())
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (n) =>
                n.title.contains(searchQuery.value) ||
                n.summary.contains(searchQuery.value),
          )
          .toList();
    }

    return list;
  }

  NewsModel? get featuredNews =>
      _repo.featuredList.isNotEmpty ? _repo.featuredList.first : null;

  void selectCategory(String cat) {
    selectedCategory.value = cat; // بدون update()
  }

  void search(String q) {
    searchQuery.value = q; // بدون update()
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // لا حاجة لـ update()
  }
}
