import 'package:json_annotation/json_annotation.dart';

part 'pull_request.g.dart';

@JsonSerializable()
class PullRequest {
  final PullRequestStatus status;
  final String title;
  final Uri url;

  PullRequest({
    this.status,
    this.title,
    this.url,
  });

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other == null) {
      return false;
    }

    if (other is PullRequest) {
      return url == other.url;
    }

    return false;
  }

  static PullRequest fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return _$PullRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PullRequestToJson(this);
}

enum PullRequestStatus {
  open,
  closed,
  merged,
}
