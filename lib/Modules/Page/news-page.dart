import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/news-list.dart';


class NewsPage extends StatefulWidget {
  final int hotelId;
  final String startDate;
  final String endDate;

  const NewsPage({Key? key , required this.hotelId, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>{
  final APIService apiService = GetIt.I<APIService>();

  @override
  void initState() {
    super.initState();
    apiService.fetchNews(widget.hotelId, DateTime.parse(widget.startDate), DateTime.parse(widget.endDate));
  }

  @override
  Widget build(BuildContext context){
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child:Scaffold(
        appBar:AppBar(
          backgroundColor: background,
          toolbarHeight: 25,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: primary,
            height: 50,
            child:Center(
              child:Text('Duyurunuz Var!', style: boldTextStyle.copyWith(color: appText, fontSize: 20)),
            ),
          ),
        ),

        body:StreamBuilder(
          stream: apiService.news$.stream,
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: Text('Loading...', style: boldTextStyle.copyWith(color: appText),),);
            }
            final news = snapshot.data!;

            news.sort((a,b) =>
              DateTime.parse(b.startDate).compareTo(DateTime.parse(a.startDate))
            );

            return Container(
                color: background,
                child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    return NewsList(
                        news: news[index]);
                  },
                ));
          },
        ),
      )
    );
  }
}