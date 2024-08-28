import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_app/Functions.dart';

class Science extends StatefulWidget {
  const Science({super.key});

  @override
  State<Science> createState() => _ScienceState();
}

class _ScienceState extends State<Science> {
  bool _hasInternet = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection(); // التحقق من الاتصال بالإنترنت عند بداية التشغيل
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      _isRefreshing = true; // بدء عملية التحديث
    });

    await _checkInternetConnection();

    // تأخير لمحاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false; // إيقاف دائرة التحميل بعد انتهاء التحديث
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000F22),
      appBar: AppBar(
        elevation: 100,
        title: const Text(
          "Science",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'RadioCanadaBig',
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: _isRefreshing
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : _hasInternet
            ? const Column(
          children: [
            Expanded(
                child: CardNews(
                    categroy: 'Science')), // عرض الأخبار إذا كان هناك اتصال بالإنترنت
          ],
        )
            : ListView(
          children: const [
            Center(
              child: Text(
                'No internet connection',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ), // عرض رسالة عند عدم وجود اتصال بالإنترنت مع إمكانية السحب للتحديث
      ),
    );
  }
}
