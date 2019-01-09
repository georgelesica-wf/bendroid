import 'dart:convert';
import 'dart:io';

import 'package:bendroid/src/mixins/popup_menu.dart';
import 'package:bendroid/src/views/action_list_view.dart';
import 'package:bendroid/constants.dart';
import 'package:bendroid/src/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github/server.dart';
import 'package:path_provider/path_provider.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> with PopupMenu {
  static const platform = const MethodChannel('app.channel.shared.data');

  Set<PullRequest> history = Set<PullRequest>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('settings'),
      appBar: AppBar(
        key: Key('settings-app-bar'),
        leading: const Icon(Icons.child_care),
        title: const Text('History'),
        actions: <Widget>[
          popupMenu(context),
        ],
        automaticallyImplyLeading: true,
      ),
      body: _body(),
    );
  }

  void createFile(Map<String, dynamic> content) {
    myHistoryFile.createSync();
    fileExists = true;
    myHistoryFile.writeAsStringSync(json.encode(content));
    this.setState(() => history = content);
  }

  void getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedPrUrl");
    if (sharedData != null) {
      List link = sharedData.replaceAll(homeLink, '').split('/');
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

  Widget historyItem(String prName, Map<String, dynamic> prInfo) {
    return ListTile(
      key: Key(prInfo['url']),
      title: Text(prName),
      subtitle: Text(prInfo['useTime'].toString()),
      onTap: () => historyTapHandler(prName),
    );
  }

  void historyTapHandler(String prName) {
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
    setDocumentInformation();
  }

  void setDocumentInformation() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File myHistoryFile = new File(directory.path + '/' + fileName);
    bool fileExists = myHistoryFile.existsSync();
    Map<String, dynamic> myHistory =
        json.decode(await myHistoryFile.readAsString());
    if (fileExists) {
      this.setState(() {
        history = myHistory;
      });
    }
    getSharedText();

    // var github = createGitHubClient();
    // github.pullRequests
    //     .get(new RepositorySlug("olesiathoms-wk", "bendroid"), 1);
  }

  List<String> sortHistoryKeys() {
    final List<String> keys = history.keys.toList();
    // Sort keys from the most recent to the oldest one
    keys.sort((key, nextKey) =>
        history['$nextKey']['useTime'] - history['$key']['useTime']);
    return keys;
  }

  void updateFile(String prName) async {
    Map<String, dynamic> newContent = {
      'url': history['$prName']['url'],
      'useTime': DateTime.now().millisecondsSinceEpoch
    };
    Map<String, dynamic> myHistoryContent =
        json.decode(await myHistoryFile.readAsString());
    myHistoryContent.update(prName, (_) => newContent);
    myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
    this.setState(() => history = myHistoryContent);
    // });
  }

  void writeToFile(String prName, String prUrl) async {
    Map<String, dynamic> newContent = {
      prName: {'url': prUrl, 'useTime': DateTime.now().millisecondsSinceEpoch}
    };
    if (fileExists) {
      Map<String, dynamic> myHistoryContent =
          json.decode(await myHistoryFile.readAsString());

      if (myHistoryContent.keys.length >= historyLimit) {
        final keys = sortHistoryKeys();
        myHistoryContent.remove(keys[historyLimit - 1]);
      }
      myHistoryContent.addAll(newContent);
      myHistoryFile.writeAsStringSync(json.encode(myHistoryContent));
      this.setState(() => history = myHistoryContent);
    } else {
      createFile(newContent);
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
