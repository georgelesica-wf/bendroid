import 'package:bendroid/settings_controller.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _adapterValue;

  String _hipChatTokenValue;

  String _gitHubTokenValue;

  String _hipChatEndpointValue;
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

  String get _gitHubToken => _gitHubTokenValue ?? '';

  set _gitHubToken(String value) {
    saveGitHubToken(value).then((_) {
      loadGitHubToken().then((newValue) {
        setState(() {
          _gitHubTokenValue = newValue;
        });
      });
    });
  }

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  String pickToken(String tokenName) {
    switch (tokenName) {
      case 'GitHub':
        return _gitHubToken;
      default:
        return _hipChatToken;
    }
  }

  void setToken(String tokenName, String value) {
    switch (tokenName) {
      case 'GitHub':
        _gitHubToken = value;
        break;
      default:
        _hipChatToken = value;
    }
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

  Widget _adapterSettingTile() {
    return ListTile(
      key: Key('adapter'),
      title: const Text('Adapter'),
      subtitle: Text(_adapter),
      onTap: _adapterDialog,
    );
  }

  Widget _body() {
    return ListView(
      key: Key('body-list'),
      children: <Widget>[
        _adapterSettingTile(),
        _tokenSettingTile('HipChat'),
        _hipChatEndpointSettingTile(),
        _tokenSettingTile('GitHub'),
      ],
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

  Future<void> _loadSettings() async {
    final loadedAdapter = await loadAdapter();
    final loadedGitHubToken = await loadGitHubToken();
    final loadedHipChatToken = await loadHipChatToken();
    final loadedHipChatEndpoint = await loadHipChatEndpoint();

    setState(() {
      _adapterValue = loadedAdapter;
      _gitHubTokenValue = loadedGitHubToken;
      _hipChatTokenValue = loadedHipChatToken;
      _hipChatEndpointValue = loadedHipChatEndpoint;
    });
  }

  Future<void> _tokenDialog(String title, String token) async {
    final controller = TextEditingController(text: token);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          key: Key('dialog'),
          title: Text('$title Token'),
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
                setToken(title, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tokenSettingTile(String title) {
    var token = pickToken(title);
    return ListTile(
      key: Key('$title-token'),
      title: Text('$title Token'),
      subtitle: _tokenSubtitle(title, token),
      onTap: () => _tokenDialog(title, token),
      onLongPress: () {
        setToken(title, '');
      },
    );
  }

  Widget _tokenSubtitle(String title, String token) {
    if (token == '') {
      return Text(
        'Required for the $title adapter',
        style: TextStyle(
          color: Colors.redAccent,
        ),
      );
    }

    return Text(token);
  }
}
