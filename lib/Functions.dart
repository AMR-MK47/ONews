import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'NewService.dart';

class CardNews extends StatefulWidget {
  const CardNews({super.key, required this.categroy});
  final String categroy;

  @override
  State<CardNews> createState() => _CardNewsState();
}

class _CardNewsState extends State<CardNews> {
  late Future<List<Article>> fetchedArticles;

  @override
  void initState() {
    super.initState();
    fetchedArticles = NewsService(Dio()).getNews(categroy: widget.categroy);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: fetchedArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Oops, there was an error, try later.'));
        } else if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              NewsListView(articles: snapshot.data!),
            ],
          );
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}

class NewsListView extends StatelessWidget {
  final List<Article> articles;

  const NewsListView({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: NewsCategry(article: articles[index]),
          );
        },
        childCount: articles.length,
      ),
    );
  }
}

class NewsCategry extends StatelessWidget {
  final Article article;

  const NewsCategry({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(article.image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'RadioCanadaBig',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          article.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'RadioCanadaBig',
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}