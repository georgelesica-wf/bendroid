import 'package:bender/bender_vm.dart';
import 'package:bendroid/src/views/history_view.dart';
import 'package:bendroid/src/controllers/settings_controller.dart';
import 'package:flutter/material.dart';

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
      home: HistoryView(
        title: 'History',
      ),
    );
  }
}
