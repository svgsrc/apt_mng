import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/News.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';

class NewsList extends StatefulWidget {
  final News news;
  final APIService apiService = GetIt.I<APIService>();

  NewsList({super.key, required this.news});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.news.content,
              style: boldTextStyle.copyWith(fontSize: 16, color: appText),
            ),
            SizedBox(height: 10),
            Text(
              'Başlangıç Tarihi: ${widget.news.startDate}',
              style: normalTextStyle.copyWith(fontSize: 14, color: appText),
            ),
            Text(
              'Bitiş Tarihi: ${widget.news.endDate}',
              style: normalTextStyle.copyWith(fontSize: 14, color: appText),
            ),
          ],
        ),
      ),
    );
  }
}