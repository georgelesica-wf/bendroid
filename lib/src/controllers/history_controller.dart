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
      List<Map<String, dynamic>> list =
          json.decode(await myHistoryFile.readAsString());
      return HistoryItem.listFromJson(list);
    } catch (err) {
      return [];
    }
  }

  Future<void> insert(PullRequest pullRequest) async {
    HistoryItem historyItem =
        new HistoryItem(pullRequest: pullRequest, timestamp: DateTime.now());
    
    print('myPullRequest  title: ${pullRequest.title}   url:${pullRequest.url}  status:  ${pullRequest.status}');
    print('item exist ${_items != null}');
    if (_items == null) {
      print('no items');
      final list = await getList();
      _items = list.toSet()..add(historyItem);

      _items.map((item)=> print('my history items, empty list: $item'));

      Directory directory = await getApplicationDocumentsDirectory();
      new File(directory.path + '/' + fileName)
          .writeAsString(json.encode(_items.toString()));
    } else {
      print('some items');
      _items.add(historyItem);

      _items.map((item)=> print('my history items : $item'));


      final sortedList = _items.toList();
      sortedList
          .sort((key, nextKey) => nextKey.timestamp.compareTo(key.timestamp));
      _items = sortedList.take(historyLimit).toSet();

      Directory directory = await getApplicationDocumentsDirectory();
      new File(directory.path + '/' + fileName)
          .writeAsString(json.encode(_items.toString()));
    }
  }
}
