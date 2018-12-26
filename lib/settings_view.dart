import 'package:bendroid/settings_controller.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _adapterValue;

  String get _adapter => _adapterValue ?? '';

  set _adapter(String value) {
    saveAdapter(value).then((_) {
      loadAdapter().then((newValue) {
        setState(() {
          _adapterValue = newValue;
        });
      });
    });
  }

  String _hipChatTokenValue;

  String get _hipChatToken => _hipChatTokenValue ?? '';

  set _hipChatToken(String value) {
    saveHipChatToken(value).then((_) {
      loadHipChatToken().then((newValue) {
        setState(() {
          _hipChatTokenValue = newValue;
        });
      });
    });
  }

  String _hipChatEndpointValue;

  String get _hipChatEndpoint => _hipChatEndpointValue ?? '';

  set _hipChatEndpoint(String value) {
    saveHipChatEndpoint(value).then((_) {
      loadHipChatEndpoint().then((newValue) {
        setState(() {
          _hipChatEndpointValue = newValue;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('settings'),
      appBar: AppBar(
        key: Key('settings-app-bar'),
        title: const Text('Bendroid Settings'),
        automaticallyImplyLeading: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      key: Key('body-list'),
      children: <Widget>[
        _adapterSettingTile(),
        _hipChatTokenSettingTile(),
        _hipChatEndpointSettingTile(),
      ],
    );
  }

  Widget _adapterSettingTile() {
    return ListTile(
      key: Key('adapter'),
      title: const Text('Adapter'),
      subtitle: Text(_adapter),
      onTap: _adapterDialog,
    );
  }

  Future<void> _adapterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Adapter / Transport'),
          children: <Widget>[
            _adapterOption(hipChatAdapter),
            _adapterOption(slackAdapter),
          ],
        );
      },
    );
  }

  Widget _adapterOption(String option) {
    return SimpleDialogOption(
      key: Key(option),
      onPressed: () {
        setState(() {
          _adapter = option;
        });
        Navigator.of(context).pop();
      },
      child: Text(option),
    );
  }

  Widget _hipChatTokenSettingTile() {
    return ListTile(
      key: Key('hipChat-token'),
      title: const Text('HipChat Token'),
      subtitle: _hipChatTokenSubtitle(),
      onTap: _hipChatTokenDialog,
      onLongPress: () {
        _hipChatToken = null;
      },
    );
  }

  Widget _hipChatTokenSubtitle() {
    if (_hipChatToken == '') {
      return const Text(
        'Required for the HipChat adapter',
        style: TextStyle(
          color: Colors.redAccent,
        ),
      );
    }

    return Text(_hipChatToken);
  }

  Future<void> _hipChatTokenDialog() async {
    final controller = TextEditingController(text: _hipChatToken);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          key: Key('dialog'),
          title: const Text('HipChat Token'),
          content: TextField(
            autofocus: true,
            controller: controller,
            key: Key('text-field'),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Text("OK"),
              onPressed: () {
                _hipChatToken = controller.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _hipChatEndpointSettingTile() {
    return ListTile(
      key: Key('endpoint'),
      title: const Text('HipChat Endpoint'),
      subtitle: Text(_hipChatEndpoint),
      onTap: _hipChatEndpointDialog,
      onLongPress: () {
        _hipChatEndpoint = null;
      },
    );
  }

  Future<void> _hipChatEndpointDialog() async {
    final controller = TextEditingController(text: _hipChatEndpoint);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          key: Key('dialog'),
          title: const Text('HipChat Endpoint'),
          content: TextField(
            autofocus: true,
            controller: controller,
            key: Key('text-field'),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Text("OK"),
              onPressed: () {
                _hipChatEndpoint = controller.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadSettings() async {
    final loadedAdapter = await loadAdapter();
    final loadedHipChatToken = await loadHipChatToken();
    final loadedHipChatEndpoint = await loadHipChatEndpoint();

    setState(() {
      _adapterValue = loadedAdapter;
      _hipChatTokenValue = loadedHipChatToken;
      _hipChatEndpointValue = loadedHipChatEndpoint;
    });
  }
}
