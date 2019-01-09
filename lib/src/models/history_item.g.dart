// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryItem _$HistoryItemFromJson(Map<String, dynamic> json) {
  return HistoryItem(
      pullRequest: json['pullRequest'] == null
          ? null
          : PullRequest.fromJson(json['pullRequest'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as int);
}

Map<String, dynamic> _$HistoryItemToJson(HistoryItem instance) =>
    <String, dynamic>{
      'pullRequest': instance.pullRequest,
      'timestamp': instance.timestamp
    };
