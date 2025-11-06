// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyResponse _$GiphyResponseFromJson(Map<String, dynamic> json) =>
    GiphyResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => GiphyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GiphyResponseToJson(GiphyResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
      'meta': instance.meta,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  totalCount: (json['total_count'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'count': instance.count,
      'offset': instance.offset,
    };
