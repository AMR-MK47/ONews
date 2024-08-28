import 'package:dio/dio.dart';

class NewsService {
  final Dio dio;

  NewsService(this.dio);

  Future<List<Article>> getGeneralNews() async {
    try {

      var response = await dio.get(
          'https://newsapi.org/v2/everything?q=NBA&apiKey=a1e0849a91ac479bb0335992be511afe');
      Map<String, dynamic> responseData = response.data;
      List<dynamic> articles = responseData['articles'];
      List<Article> articleModel = [];
      for (var item in articles) {
        Article article = Article(
          image: item['urlToImage'] ?? 'https://via.placeholder.com/400x200?text=No+Image+Available', // Handle null images
          author: item['author'] ?? 'Unknown Author',
          description: item['description'] ?? 'No description available',
          title: item['title'] ?? 'No title available',
        );
        articleModel.add(article);
      }
      return articleModel;
    } catch (e) {
      print("Error fetching news: $e");
      return []; // Return an empty list on error
    }
  }
  Future<List<Article>> getNews({required String categroy}) async {
    try {

      var response = await dio.get(
          'https://newsapi.org/v2/top-headlines?country=us&category=$categroy&apiKey=a1e0849a91ac479bb0335992be511afe');
      Map<String, dynamic> responseData = response.data;
      List<dynamic> articles = responseData['articles'];
      List<Article> articleModel = [];
      for (var item in articles) {
        Article article = Article(
          image: item['urlToImage'] ?? 'https://via.placeholder.com/400x200?text=No+Image+Available', // Handle null images
          author: item['author'] ?? 'Unknown Author',
          description: item['description'] ?? 'No description available',
          title: item['title'] ?? 'No title available',
        );
        articleModel.add(article);
      }
      return articleModel;
    } catch (e) {
      print("Error fetching news: $e");
      return []; // Return an empty list on error
    }
  }
}

class Article {
  String image;
  String title;
  String description;
  String author;

  Article({
    required this.image,
    required this.title,
    required this.description,
    required this.author,
  });
}
