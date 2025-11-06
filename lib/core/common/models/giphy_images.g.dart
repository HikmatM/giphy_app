// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyImages _$GiphyImagesFromJson(Map<String, dynamic> json) => GiphyImages(
  fixedHeightSmall: json['fixed_height_small'] == null
      ? null
      : GiphyImageData.fromJson(
          json['fixed_height_small'] as Map<String, dynamic>,
        ),
  fixedHeight: json['fixed_height'] == null
      ? null
      : GiphyImageData.fromJson(json['fixed_height'] as Map<String, dynamic>),
  fixedWidthSmall: json['fixed_width_small'] == null
      ? null
      : GiphyImageData.fromJson(
          json['fixed_width_small'] as Map<String, dynamic>,
        ),
  fixedWidth: json['fixed_width'] == null
      ? null
      : GiphyImageData.fromJson(json['fixed_width'] as Map<String, dynamic>),
  original: json['original'] == null
      ? null
      : GiphyImageData.fromJson(json['original'] as Map<String, dynamic>),
  downsized: json['downsized'] == null
      ? null
      : GiphyImageData.fromJson(json['downsized'] as Map<String, dynamic>),
  downsizedSmall: json['downsized_small'] == null
      ? null
      : GiphyImageData.fromJson(
          json['downsized_small'] as Map<String, dynamic>,
        ),
  downsizedMedium: json['downsized_medium'] == null
      ? null
      : GiphyImageData.fromJson(
          json['downsized_medium'] as Map<String, dynamic>,
        ),
  downsizedLarge: json['downsized_large'] == null
      ? null
      : GiphyImageData.fromJson(
          json['downsized_large'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GiphyImagesToJson(GiphyImages instance) =>
    <String, dynamic>{
      'fixed_height_small': instance.fixedHeightSmall,
      'fixed_height': instance.fixedHeight,
      'fixed_width_small': instance.fixedWidthSmall,
      'fixed_width': instance.fixedWidth,
      'original': instance.original,
      'downsized': instance.downsized,
      'downsized_small': instance.downsizedSmall,
      'downsized_medium': instance.downsizedMedium,
      'downsized_large': instance.downsizedLarge,
    };
