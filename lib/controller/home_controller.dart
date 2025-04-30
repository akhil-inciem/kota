import 'package:get/get.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/news_model.dart';
import 'package:kota/model/user_model.dart';
import '../constants/app_constants.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  final isLoading = true.obs;
  final newsItems = <Datum>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsItems();
  }

  Future<void> fetchNewsItems() async {
    isLoading.value = true;

    try {
      NewsModel news = NewsModel.fromJson(DummyData.news);
      // final fetchedNews = await NewsApiService().fetchNews();
      newsItems.assignAll(news.data);
      isLoading.value = false;
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
