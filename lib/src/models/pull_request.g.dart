// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PullRequest _$PullRequestFromJson(Map<String, dynamic> json) {
  return PullRequest(
      status: _$enumDecodeNullable(_$PullRequestStatusEnumMap, json['status']),
      title: json['title'] as String,
      url: json['url'] == null ? null : Uri.parse(json['url'] as String));
}

Map<String, dynamic> _$PullRequestToJson(PullRequest instance) =>
    <String, dynamic>{
      'status': _$PullRequestStatusEnumMap[instance.status],
      'title': instance.title,
      'url': instance.url?.toString()
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$PullRequestStatusEnumMap = <PullRequestStatus, dynamic>{
  PullRequestStatus.open: 'open',
  PullRequestStatus.closed: 'closed',
  PullRequestStatus.merged: 'merged'
};
