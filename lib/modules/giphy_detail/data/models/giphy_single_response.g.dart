// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_single_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphySingleResponse _$GiphySingleResponseFromJson(Map<String, dynamic> json) =>
    GiphySingleResponse(
      data: GiphyData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GiphySingleResponseToJson(
  GiphySingleResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
