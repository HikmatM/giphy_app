// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  status: (json['status'] as num).toInt(),
  msg: json['msg'] as String,
  responseId: json['responseId'] as String?,
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'responseId': instance.responseId,
};
