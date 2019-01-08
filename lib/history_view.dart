import 'dart:convert';
import 'dart:io';

import 'package:bendroid/action_list_view.dart';
import 'package:bendroid/constants.dart';
import 'package:bendroid/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HistoryView extends StatefulWidget {
  
  HistoryView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>{

  static const platform = const MethodChannel('app.channel.shared.data');
  File myHistoryFile;
  String directoryPath;
  bool fileExists = false;
  Map <String, dynamic> history = {};

  @override void initState(){
    super.initState();
    getApplicationDocumentsDirectory().then((Directory dir) {
      directoryPath = dir.path;
      myHistoryFile = new File(directoryPath + '/' + Constants.fileName);
      fileExists = myHistoryFile.existsSync();
      if(fileExists){
        this.setState(() => history = json.decode(myHistoryFile.readAsStringSync()));
      }
    }).then((_){
    print('\n\nhistory $history,               file exist: $fileExists ');
    getSharedText();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('settings'),
      appBar: AppBar(
        key: Key('settings-app-bar'),
        leading: const Icon(Icons.child_care),
        title: const Text('History'),
        actions:
          <Widget>[ 
            PopupMenuButton<String>(
              icon: const Icon(
                  Icons.dehaze,
                ),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value:choice,
                    child:Text(choice),
                  );
                }).toList();
              }
            ),
          ],
        automaticallyImplyLeading: true,
      ),
      body: _body(),
    );
  }

    Widget _body() {
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

      final List<String> keys = history.keys.toList();
      print('before sorting  $keys');
      keys.sort((key,nextKey) => history['$nextKey']['useTime'] - history['$key']['useTime']);

      print('after sorting  $keys');
      return ListView(
        key: Key('<history-list'),
        children: keys.map((key) => historyItem(key.toString(), history['$key'])).toList()
        
      );
    }
    Widget historyItem(prName, prInfo) {
      print('name $prName, url: ${prInfo['url']}, useTime: ${prInfo['useTime']} ');
      return ListTile(
        key: Key(prInfo['url']),
        title: Text(prName),
        subtitle: Text(prInfo['useTime'].toString()),
        onTap: () => historyTapHandler(prName),
      );
    }

    void choiceAction(choice) {
      switch (choice) {
        default:
          handleSettings();
      }
    }

    void createFile(content){
      myHistoryFile.createSync();
      fileExists = true;
      myHistoryFile.writeAsStringSync(json.encode(content));
      this.setState(() => history = json.decode(myHistoryFile.readAsStringSync()));
      print('file created  $fileExists, new history: $history');
    }

    void getSharedText() async {
      var sharedData = await platform.invokeMethod("getSharedPrUrl");
      if (sharedData != null) {
        List link = sharedData.replaceAll(Constants.homeLink,'').split('/');
        String prName = link[0]+'-'+ link[link.length-1];
        writeToFile(prName, sharedData);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActionListView(prName: prName, prHistory: history),
          ),
        );
      }
    }

    void handleSettings() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SettingsView(),
        ),
      );
    }
    void historyTapHandler(prName) {
      updateFile(prName);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ActionListView(prName: prName, prHistory: history),
        ),
      );
    }

    void updateFile(prName){
        Map<String, dynamic> content = {'url': history['$prName']['url'], 'useTime': DateTime.now().millisecondsSinceEpoch};
        Map<String, dynamic> myHistoryContent = json.decode(myHistoryFile.readAsStringSync());
        myHistoryContent.update(prName , (_) => content);
        myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
        this.setState(() => history = json.decode(myHistoryFile.readAsStringSync()));
    }

    void writeToFile(prName, prUrl) {
      Map <String, dynamic> content = {prName: {'url': prUrl, 'useTime': DateTime.now().millisecondsSinceEpoch}};
      if(fileExists){
        Map<String, dynamic> myHistoryContent = json.decode(myHistoryFile.readAsStringSync());
        myHistoryContent.addAll(content);
        myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
        this.setState(() => history = json.decode(myHistoryFile.readAsStringSync()));
      }else{
        createFile(content);
      }
    }
    

}