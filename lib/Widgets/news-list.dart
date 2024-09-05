import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/News.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class NewsList extends StatefulWidget {
  final News news;
  final APIService apiService = GetIt.I<APIService>();

  NewsList({super.key, required this.news});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d.M.yy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child:ListTile(
          leading: Icon( Icons.notifications, color: primary, size: 30),
          title: Text(
            widget.news.content,
            style: boldTextStyle.copyWith(fontSize: 16),
          ),
          subtitle: Text(
            formatDate(widget.news.startDate.toString()),
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        )

      ),
    );
  }
}