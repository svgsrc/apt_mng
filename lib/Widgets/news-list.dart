import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/News.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewsList extends StatefulWidget {
  final News news;
  final APIService apiService = GetIt.I<APIService>();

  NewsList({super.key, required this.news});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  String formatDate(String date) {
    initializeDateFormatting('tr_TR', null);
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy', 'tr_TR').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.notifications, color: Colors.blue, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.news.content,
                    style: boldTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatDate(widget.news.startDate.toString()),
                  style: boldTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  ' - ',
                  style: boldTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  formatDate(widget.news.endDate.toString()),
                  style: boldTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
