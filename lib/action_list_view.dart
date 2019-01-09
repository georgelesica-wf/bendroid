import 'package:bender/bender_vm.dart';
import 'package:bendroid/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionListView extends StatefulWidget {
  final String prName;

  final Map prHistory;
  final String title;
  ActionListView(
      {Key key, this.title = 'Bendroid Actions', this.prName, this.prHistory})
      : super(key: key);

  @override
  _ActionListViewState createState() => _ActionListViewState();
}

class _ActionListViewState extends State<ActionListView> {
  bool _isWaiting = false;

  String _prUrl = '';
  String _prName = '';

  TextEditingController _urlController = TextEditingController(text: '');

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

      getBenderAdapter().then((adapter) {
        return adapter(action.message);
      }).then((receipt) {
        if (receipt.wasSuccessful) {
          print('Bendroid Message Succeeded');
        } else {
          print(receipt.toString());
        }

        setState(() {
          _isWaiting = false;
        });
      });
    };
  }

  Widget body() {
    return Column(
      key: Key('body'),
      children: <Widget>[
        urlBar(),
        Expanded(
          key: Key('expanded'),
          child: actionList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: body(),
    );
  }

  Action configureAction(Action action) {
    setParameterValue<Uri>(
        action, PrParameter.parameterName, Uri.parse(_prUrl));
    return action;
  }

  @override
  void initState() {
    super.initState();
    _prName = widget.prName;
    _prUrl = widget.prHistory['$_prName']['url'];
    _urlController.text = widget.prName;
  }

  bool isRunnable(Action action) {
    return action.isRunnable(action);
  }

  Widget urlBar() {
    return TextField(
      controller: _urlController,
      keyboardType: TextInputType.url,
      onChanged: (value) {
        setState(() {
          _prName = value;
        });
      },
      style: Theme.of(context).textTheme.title,
      decoration: InputDecoration(
        hintText: 'Pull request URL',
        contentPadding: EdgeInsets.all(16.0),
      ),
      key: Key('url-bar'),
    );
  }
}
