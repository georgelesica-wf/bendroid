import 'dart:convert';
import 'dart:io';

import 'package:bendroid/constants.dart';
import 'package:bendroid/src/models/history_item.dart';
import 'package:bendroid/src/models/pull_request.dart';
import 'package:path_provider/path_provider.dart';

class HistoryController {
  Set<HistoryItem> _items;

  Future<Iterable<HistoryItem>> getList() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File myHistoryFile = new File(directory.path + '/' + fileName);
    try {
      List<dynamic> list = jsonDecode(await myHistoryFile.readAsString());
      return HistoryItem.listFromJson(list);
    } catch (err) {
      return [];
    }
  }

  Future<void> insert(PullRequest pullRequest) async {
    HistoryItem historyItem =
        new HistoryItem(pullRequest: pullRequest, timestamp: DateTime.now());
    if (_items == null) {
      final list = await getList();
      _items = list.toSet()..add(historyItem);

      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/' + fileName);
      await file.writeAsString(
          jsonEncode(_items.map((item) => item.toJson()).toList()));
    } else {
      bool isPullRequestExist =_items.contains(historyItem);
      print('pullRequestExist $isPullRequestExist');
      if(isPullRequestExist){
        _items.remove(historyItem);
      }
      _items.add(historyItem);

      final sortedList = _items.toList();
      sortedList
          .sort((key, nextKey) => nextKey.timestamp.compareTo(key.timestamp));
      _items = sortedList.take(historyLimit).toSet();

      Directory directory = await getApplicationDocumentsDirectory();
      await new File(directory.path + '/' + fileName).writeAsString(
          jsonEncode(_items.map((item) => item.toJson()).toList()));
    }
  }
}
