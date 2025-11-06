// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyData _$GiphyDataFromJson(Map<String, dynamic> json) => GiphyData(
  id: json['id'] as String,
  title: json['title'] as String,
  type: json['type'] as String,
  rating: json['rating'] as String?,
  username: json['username'] as String?,
  source: json['source'] as String?,
  url: json['url'] as String?,
  embedUrl: json['embedUrl'] as String?,
  images: GiphyImages.fromJson(json['images'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GiphyDataToJson(GiphyData instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'rating': instance.rating,
  'username': instance.username,
  'source': instance.source,
  'url': instance.url,
  'embedUrl': instance.embedUrl,
  'images': instance.images,
};
