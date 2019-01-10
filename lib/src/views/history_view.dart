import 'package:bendroid/constants.dart';
import 'package:bendroid/src/controllers/history_controller.dart';
import 'package:bendroid/src/mixins/popup_menu.dart';
import 'package:bendroid/src/models/history_item.dart';
import 'package:bendroid/src/models/pull_request.dart';
import 'package:bendroid/src/views/action_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> with PopupMenu {
  static const platform = const MethodChannel('app.channel.shared.data');
  HistoryController historyController = new HistoryController();
  List<HistoryItem> history = List<HistoryItem>();

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

  Future<void> getHistory() async {
    // List<HistoryItem> myHistory = await 
    historyController.getList();
    // myHistory
    //     .sort((key, nextKey) => nextKey.timestamp.compareTo(key.timestamp));
    // print('myHistory     $myHistory');
    // this.setState(() => history = myHistory);
  }

  void getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedPrUrl");
    if (sharedData != null) {
      List link = sharedData.replaceAll(homeLink, '').split('/');
      String prName = link[0] + '-' + link[link.length - 1];

      PullRequest pullRequest = new PullRequest(
          status: PullRequestStatus.open,
          title: prName,
          url: Uri.parse(sharedData));

      await historyController.insert(pullRequest);
      // await getHistory();

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ActionListView(pullRequest: pullRequest)),
      );
    }
  }

  Widget historyItem(HistoryItem historyItem) {
    return ListTile(
      key: Key(historyItem.pullRequest.url.toString()),
      title: Text(historyItem.pullRequest.title),
      subtitle: Text(historyItem.timestamp.toLocal().toString()),
      onTap: () => historyTapHandler(historyItem.pullRequest),
    );
  }

  void historyTapHandler(PullRequest pullRequest) {
    historyController.insert(pullRequest);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActionListView(pullRequest: pullRequest),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveInformation();
  }

  void retrieveInformation() async{
      await getHistory();
      getSharedText();
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
        children: history.map((key) => historyItem(key)).toList());
  }
}
