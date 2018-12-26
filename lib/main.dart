import 'package:bender/bender_vm.dart';
import 'package:bendroid/settings_controller.dart';
import 'package:bendroid/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<BenderAdapter> getBenderAdapter() async {
  final adapter = await loadAdapter();

  if (adapter == hipChatAdapter) {
    final hipChatEndpoint = await loadHipChatEndpoint();
    final hipChatToken = await loadHipChatToken();
    return getHipChatAdapter(
        endpoint: Uri.parse(hipChatEndpoint), token: hipChatToken);
  }

  if (adapter == slackAdapter) {
    return getSlackAdapter(token: '');
  }

  return getConsoleAdapter();
}

void main() {
  runApp(BendroidApp());
}

class BendroidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bendroid',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: ActionListView(
        title: 'Bendroid Actions',
      ),
    );
  }
}

class ActionListView extends StatefulWidget {
  ActionListView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ActionListViewState createState() => _ActionListViewState();
}

class _ActionListViewState extends State<ActionListView> {
  static const platform = const MethodChannel('app.channel.shared.data');

  bool _isWaiting = false;

  String _prUrl = '';

  TextEditingController _urlController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    getSharedText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: handleSettings,
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: body(),
    );
  }

  void handleSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsView(),
      ),
    );
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

  void getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedPrUrl");
    if (sharedData != null) {
      setState(() {
        _prUrl = sharedData;
        _urlController.text = sharedData;
      });
    }
  }

  Widget urlBar() {
    return TextField(
      controller: _urlController,
      keyboardType: TextInputType.url,
      onChanged: (value) {
        setState(() {
          _prUrl = value;
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

  Widget actionItem(Action action) {
    return ListTile(
      key: Key(action.key),
      title: Text(action.name),
      subtitle: Text(action.helpText),
      enabled: !_isWaiting && action.isRunnable(action),
      onTap: actionTapHandler(action),
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

  Action configureAction(Action action) {
    setParameterValue<Uri>(
        action, PrParameter.parameterName, Uri.parse(_prUrl));
    return action;
  }

  bool isRunnable(Action action) {
    return action.isRunnable(action);
  }
}
