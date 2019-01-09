import 'package:bendroid/src/models/history_item.dart';
import 'package:bendroid/src/models/pull_request.dart';

class HistoryController {
  List<HistoryItem> _items = <HistoryItem>[];

  Iterable<PullRequest> getList() {}

  void insert(PullRequest pullRequest) {}
}
