import 'package:bendroid/src/views/settings_view.dart';
import 'package:flutter/material.dart';

class PopupMenu {
  Widget popupMenu(BuildContext context) {
    return PopupMenuButton<PopupMenuChoice>(
        icon: const Icon(
          Icons.dehaze,
        ),
        onSelected: (choice) {
          switch (choice) {
            case PopupMenuChoice.settings:
              showSettings(context);
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<PopupMenuChoice>(
              value: PopupMenuChoice.settings,
              child: const Text('Settings'),
            ),
          ];
        });
  }

  void showSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsView(),
      ),
    );
  }
}

enum PopupMenuChoice {
  settings,
}
