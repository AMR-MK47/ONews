import 'package:flutter/material.dart';
import 'package:news_app/Cards.dart';
import 'package:news_app/NewsList.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // مكتبة الاتصال

void main() {
  runApp(const HomeWidget());
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _isRefreshing = false;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection(); // التحقق من الاتصال عند بدء تشغيل التطبيق
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      _isRefreshing = true;
    });

    await _checkInternetConnection();

    if (_hasInternet) {
      // تأخير لمحاكاة تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));
    }

    // إعادة تحميل البيانات
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff000F22),
        appBar: AppBar(
          elevation: 100,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "O",
                style: TextStyle(
                    color: Color(0xff5482B3),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RadioCanadaBig',
                    fontSize: 30),
              ),
              Text(
                "News",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RadioCanadaBig',
                    fontSize: 25),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RefreshIndicator(
            onRefresh: _refreshNews,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                const SliverToBoxAdapter(child: ListCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                _hasInternet
                    ? Newslist(
                  isRefreshing: _isRefreshing,
                  hasInternet: _hasInternet,
                )
                    : const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.white),
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
