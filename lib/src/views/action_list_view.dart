import 'package:bender/bender_vm.dart';
import 'package:bendroid/main.dart';
import 'package:bendroid/src/models/pull_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionListView extends StatefulWidget {
  final PullRequest pullRequest;

  ActionListView(
      {Key key, this.pullRequest})
      : super(key: key);

  @override
  _ActionListViewState createState() => _ActionListViewState();
}

class _ActionListViewState extends State<ActionListView> {
  bool _isWaiting = false;

  Widget actionItem(Action action) {
    return ListTile(
      key: Key(action.key),
      title: Text(action.name),
      subtitle: Text(action.helpText),
      enabled: !_isWaiting && action.isRunnable(action),
      onTap: actionTapHandler(action),
    );
  }

  Widget actionList() {
    final actions = getAllActions().map(configureAction).where(isRunnable);

    if (actions.isEmpty) {
      return Center(
        child: Text(
          'No matching actions',
          style: Theme.of(context).textTheme.display1,
          key: Key('empty-text'),
        ),
        key: Key('empty-center'),
      );
    }

    return ListView(
      key: Key('action-list'),
      children: actions.map(actionItem).toList(),
    );
  }

  VoidCallback actionTapHandler(Action action) {
    return () {
      setState(() {
        _isWaiting = true;
      });
      dispatchAction(action);
    };
  }

  Widget body() {
    return actionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pullRequest.title),
        automaticallyImplyLeading: true,
      ),
      body: body(),
    );
  }

  Action configureAction(Action action) {
    setParameterValue<Uri>(
        action, PrParameter.parameterName, widget.pullRequest.url);
    return action;
  }

  Future<void> dispatchAction(Action action) async {
    final adapter = await getBenderAdapter();
    final receipt = await adapter(action.message);

    // TODO: Communicate success or failure to the user
    if (receipt.wasSuccessful) {
      print('Bendroid message succeeded');
    } else {
      print(receipt.toString());
    }

    setState(() {
      _isWaiting = false;
    });
  }

  bool isRunnable(Action action) {
    return action.isRunnable(action);
  }
}
