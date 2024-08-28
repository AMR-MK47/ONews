import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'NewService.dart';

class Newslist extends StatefulWidget {
  final bool isRefreshing;
  final bool hasInternet;

  const Newslist({super.key, required this.isRefreshing, required this.hasInternet});

  @override
  State<Newslist> createState() => _NewslistState();
}

class _NewslistState extends State<Newslist> {
  late Future<List<Article>> fetchedArticles;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  void _fetchArticles() {
    if (widget.hasInternet) {
      fetchedArticles = NewsService(Dio()).getGeneralNews();
    } else {
      fetchedArticles = Future.error('No internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.hasInternet ? fetchedArticles : Future.error('No internet connection'),
      builder: (context, snapshot) {
        if (!widget.hasInternet) {
          print("No internet connection");
          return const SliverToBoxAdapter(child: Center(child: Text('No internet connection', style: TextStyle(color: Colors.white))));
        }
        if (widget.isRefreshing || snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                snapshot.error.toString().contains('No internet connection') ? 'No internet connection' : 'Oops, there was an error. Try again later.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          print(" internet connection");
          return NewsListView(articles: snapshot.data!);
        } else {
          return const SliverToBoxAdapter(child: Center(child: Text('No data available', style: TextStyle(color: Colors.white))));
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
        childCount: articles.length,
            (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: NewsCategry(article: articles[index]),
          );
        },
      ),
    );
  }
}
class NewsCategry extends StatelessWidget {
  final Article article;

  NewsCategry({super.key, required this.article});

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
        const SizedBox(height: 20), // Adding spacing between articles
      ],
    );
  }
}