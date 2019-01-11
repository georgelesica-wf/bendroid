import 'package:bendroid/src/models/pull_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_item.g.dart';

@JsonSerializable()
class HistoryItem {
  @JsonKey(toJson: _pullRequestToJson, fromJson: _pullRequestFromJson)
  final PullRequest pullRequest;
  final DateTime timestamp;

  HistoryItem({
    this.pullRequest,
    this.timestamp,
  });

  @override
  int get hashCode => pullRequest.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other == null) {
      return false;
    }

    if (other is HistoryItem) {
      return pullRequest == other.pullRequest;
    }

    return false;
  }

  static HistoryItem fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return _$HistoryItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HistoryItemToJson(this);

  static Iterable<HistoryItem> listFromJson(List<dynamic> list) {
    if (list == null) {
      return null;
    }
    return list.map((item) => fromJson(item));
  }
}

Map<String, dynamic> _pullRequestToJson(PullRequest pullRequest) {
  return pullRequest.toJson();
}

PullRequest _pullRequestFromJson(Map<String, dynamic> json) {
  return PullRequest.fromJson(json);
}
