
import 'dart:io';

import 'package:bendroid/constants.dart';
import 'package:bendroid/main.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>{



  @override void initState() {
    super.initState();
    //  getApplicationDocumentsDirectory().then((Directory directory) {
    //   jsonFile = new File(directory.path + '/' + Constants.fileName);
    //   fileExists = jsonFile
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('settings'),
      appBar: AppBar(
        key: Key('settings-app-bar'),
        title: const Text('History'),
        automaticallyImplyLeading: true,
      ),
      body: _body(),
    );
  }

    Widget _body() {
      final history = 
      [{'name':'pr0','url':'http://0','id':'0'},
      {'name':'pr1','url':'http://1','id':'1'},
      {'name':'MSODP-1042 delete log, delete unnecessary','url':'https://github.com/Workiva/datatables/pull/7788','id':'2'}];
      if (history.isEmpty) {
        return Center(
          child: Text(
            'No history available at this moment',
            style: Theme.of(context).textTheme.display1,
            key: Key('empty-text'),
          ),
          key: Key('empty-center'),
        );
      }

      return ListView(
        key: Key('<history-list'),
        children: history.map(historyItem).toList(),
      );
    }
    Widget historyItem(item) {
      return ListTile(
        key: Key(item['id']),
        title: Text(item['name']),
        subtitle: Text(item['url']),
        onTap: (){historyTapHandler(item);},
      );
    }
    void historyTapHandler(item) {
      print('this is my item: $item');
      Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActionListView(info: item),
      ),
    );
    }


}