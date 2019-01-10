import 'package:bendroid/src/models/pull_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_item.g.dart';

@JsonSerializable()
class HistoryItem {
  final PullRequest pullRequest;
  final DateTime timestamp;

  HistoryItem({
    this.pullRequest,
    this.timestamp,
  });

  static HistoryItem fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return _$HistoryItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HistoryItemToJson(this);

  static Iterable<HistoryItem> listFromJson(List<Map<String, dynamic>> list) {
    print('trying to get list from json');
    if (list == null) {
      return null;
    }
    return list.map((item) => fromJson(item));
  }
}
