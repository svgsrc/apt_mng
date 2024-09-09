import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/news-list.dart';

class NewsPage extends StatefulWidget {
  final int hotelId;
  final String startDate;
  final String endDate;

  const NewsPage(
      {Key? key,
      required this.hotelId,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final APIService apiService = GetIt.I<APIService>();

  @override
  void initState() {
    super.initState();
    apiService.fetchNews(widget.hotelId, DateTime.parse(widget.startDate), DateTime.parse(widget.endDate));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
        padding: EdgeInsets.only(top: topPadding),
        child: Scaffold(
          body: StreamBuilder(
            stream: apiService.news$.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Duyuru Bulunamadı', style: normalTextStyle),
                );
              } else {
                final news = snapshot.data!;
                news.sort((a, b) => b.startDate.compareTo(a.startDate));

                return Container(
                  color: background,
                  child: ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return NewsList(news: news[index]);
                    },
                  ),

                );
              }
            },
          ),
        ));
  }
}
