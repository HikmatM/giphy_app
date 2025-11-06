// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyImageData _$GiphyImageDataFromJson(Map<String, dynamic> json) =>
    GiphyImageData(
      url: json['url'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      size: json['size'] as String?,
      mp4: json['mp4'] as String?,
      mp4Size: json['mp4Size'] as String?,
      webp: json['webp'] as String?,
      webpSize: json['webpSize'] as String?,
    );

Map<String, dynamic> _$GiphyImageDataToJson(GiphyImageData instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'mp4': instance.mp4,
      'mp4Size': instance.mp4Size,
      'webp': instance.webp,
      'webpSize': instance.webpSize,
    };
