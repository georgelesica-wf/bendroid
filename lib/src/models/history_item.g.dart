// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryItem _$HistoryItemFromJson(Map<String, dynamic> json) {
  return HistoryItem(
      pullRequest: json['pullRequest'] == null
          ? null
          : _pullRequestFromJson(json['pullRequest'] as Map<String, dynamic>),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String));
}

Map<String, dynamic> _$HistoryItemToJson(HistoryItem instance) =>
    <String, dynamic>{
      'pullRequest': instance.pullRequest == null
          ? null
          : _pullRequestToJson(instance.pullRequest),
      'timestamp': instance.timestamp?.toIso8601String()
    };
