import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

const defaultHipChatEndpoint = 'https://workiva.hipchat.com/v2/user/@Bender/message';

const String adapterKey = 'adapter';
const String hipChatTokenKey = 'hipChat-token';
const String hipChatEndpointKey = 'hipchat-endpoint';

const String hipChatAdapter = 'HipChat';
const String slackAdapter = 'Slack';

String _adapter;

String _hipChatToken;

String _hipChatEndpoint;

Future<String> loadAdapter() async {
  if (_adapter != null) {
    return _adapter;
  }

  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(adapterKey);
}

Future<void> saveAdapter(String value) async {
  if (value == _adapter) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(adapterKey, value);
  _adapter = value;
}

Future<String> loadHipChatToken() async {
  if (_hipChatToken != null) {
    return _hipChatToken;
  }

  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(hipChatTokenKey);
}

Future<void> saveHipChatToken(String value) async {
  if (value == _hipChatToken) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(hipChatTokenKey, value);
  _hipChatToken = value;
}

Future<String> loadHipChatEndpoint() async {
  if (_hipChatEndpoint != null) {
    return _hipChatEndpoint;
  }

  final prefs = await SharedPreferences.getInstance();
  final endpoint = prefs.getString(hipChatEndpointKey);

  return endpoint ?? defaultHipChatEndpoint;
}

Future<void> saveHipChatEndpoint(String value) async {
  if (value == _hipChatEndpoint) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(hipChatEndpointKey, value);
  _hipChatEndpoint = value;
}
