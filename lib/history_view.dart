import 'dart:convert';
import 'dart:io';

import 'package:bendroid/action_list_view.dart';
import 'package:bendroid/constants.dart';
import 'package:bendroid/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HistoryView extends StatefulWidget {
  final String title;

  HistoryView({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  static const platform = const MethodChannel('app.channel.shared.data');
  File myHistoryFile;
  String directoryPath;
  bool fileExists = false;
  Map<String, dynamic> history = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('settings'),
      appBar: AppBar(
        key: Key('settings-app-bar'),
        leading: const Icon(Icons.child_care),
        title: const Text('History'),
        actions: <Widget>[
          PopupMenuButton<String>(
              icon: const Icon(
                Icons.dehaze,
              ),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
        ],
        automaticallyImplyLeading: true,
      ),
      body: _body(),
    );
  }

  void choiceAction(choice) {
    switch (choice) {
      default:
        handleSettings();
    }
  }

  void createFile(content) {
    myHistoryFile.createSync();
    fileExists = true;
    myHistoryFile.writeAsStringSync(json.encode(content));
    this.setState(
        () => history = json.decode(myHistoryFile.readAsStringSync()));
  }

  void getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedPrUrl");
    if (sharedData != null) {
      List link = sharedData.replaceAll(Constants.homeLink, '').split('/');
      String prName = link[0] + '-' + link[link.length - 1];
      writeToFile(prName, sharedData);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ActionListView(prName: prName, prHistory: history),
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

  Widget historyItem(prName, prInfo) {
    return ListTile(
      key: Key(prInfo['url']),
      title: Text(prName),
      subtitle: Text(prInfo['useTime'].toString()),
      onTap: () => historyTapHandler(prName),
    );
  }

  void historyTapHandler(prName) {
    updateFile(prName);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ActionListView(prName: prName, prHistory: history),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory dir) {
      directoryPath = dir.path;
      myHistoryFile = new File(directoryPath + '/' + Constants.fileName);
      fileExists = myHistoryFile.existsSync();
      if (fileExists) {
        this.setState(
            () => history = json.decode(myHistoryFile.readAsStringSync()));
      }
    }).then((_) {
      getSharedText();
      _getFromApi('https://github.com/Workiva/text_doc_client/pull/7787');
    });
  }

  List<String> sortHistoryKeys() {
    final List<String> keys = history.keys.toList();
    // Sort keys from the most recent to the oldest one
    keys.sort((key, nextKey) =>
        history['$nextKey']['useTime'] - history['$key']['useTime']);
    return keys;
  }

  void updateFile(prName) {
    Map<String, dynamic> content = {
      'url': history['$prName']['url'],
      'useTime': DateTime.now().millisecondsSinceEpoch
    };
    Map<String, dynamic> myHistoryContent =
        json.decode(myHistoryFile.readAsStringSync());
    myHistoryContent.update(prName, (_) => content);
    myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
    this.setState(
        () => history = json.decode(myHistoryFile.readAsStringSync()));
  }

  void writeToFile(prName, prUrl) {
    Map<String, dynamic> content = {
      prName: {'url': prUrl, 'useTime': DateTime.now().millisecondsSinceEpoch}
    };
    if (fileExists) {
      Map<String, dynamic> myHistoryContent =
          json.decode(myHistoryFile.readAsStringSync());
      if (myHistoryContent.keys.length >= Constants.historyLimit) {
        final keys = sortHistoryKeys();
        myHistoryContent.remove(keys[Constants.historyLimit - 1]);
      }
      myHistoryContent.addAll(content);
      myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
      this.setState(
          () => history = json.decode(myHistoryFile.readAsStringSync()));
    } else {
      createFile(content);
    }
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

    return ListView(
        key: Key('<history-list'),
        children: sortHistoryKeys()
            .map((key) => historyItem(key.toString(), history['$key']))
            .toList());
  }

  _getFromApi(url) async {
    try {
      var httpClient = new HttpClient();
      var uri = new Uri.https('api.github.com', url);
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        print('MY OBJECT: $json');
      } else {
        print('Something went wrong');
      }
    } catch (exception) {
      NullThrownError();
    }
  }
}
