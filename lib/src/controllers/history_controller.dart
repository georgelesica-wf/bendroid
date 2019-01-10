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
    // try {
      print('trying to read file,isfileExist: ${myHistoryFile.existsSync()}');
        myHistoryFile.length().then((len) {
     print('file length $len');});

      String content = await myHistoryFile.readAsString();
      print('our content ${json.decode(content)}');

      String list = json.decode(content);

      print('list length ${list.length}');
      print('before return');
      // return HistoryItem.listFromJson(list);
    // } catch (err) {
      // return [];
    // }
  }

  Future<void> insert(PullRequest pullRequest) async {
    HistoryItem historyItem =
        new HistoryItem(pullRequest: pullRequest, timestamp: DateTime.now());
    print('item exist ${_items != null}');
    if (_items == null) {
      final list = await getList();
      _items = list.toSet()..add(historyItem);
      print('list length ${list.length}, but set lenth is "${_items.length}"');

      Directory directory = await getApplicationDocumentsDirectory();  
      File file = new File(directory.path + '/' + fileName);
      await file
          .writeAsString(json.encode(_items.toString()));
        final smthng = await getList();
      print('done writing to file ${smthng.length},but our history is ${_items.length}');
       file.length().then((len) {
     print('file length $len');});
    } else {
      _items.add(historyItem);

      final sortedList = _items.toList();
      sortedList
          .sort((key, nextKey) => nextKey.timestamp.compareTo(key.timestamp));
      _items = sortedList.take(historyLimit).toSet();

      Directory directory = await getApplicationDocumentsDirectory();
      await new File(directory.path + '/' + fileName)
          .writeAsString(json.encode(_items.toString()));
    }
  // final list = await getList();
  // print('lblljvkbj         ${list.length}');
  // list.map((item)=>print('helllo item.timestamp'));
  }
}
