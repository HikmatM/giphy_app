import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'giphy_image_data.dart';

part 'giphy_images.g.dart';

@JsonSerializable()
class GiphyImages extends Equatable {
  @JsonKey(name: 'fixed_height_small')
  final GiphyImageData? fixedHeightSmall;

  @JsonKey(name: 'fixed_height')
  final GiphyImageData? fixedHeight;

  @JsonKey(name: 'fixed_width_small')
  final GiphyImageData? fixedWidthSmall;

  @JsonKey(name: 'fixed_width')
  final GiphyImageData? fixedWidth;

  @JsonKey(name: 'original')
  final GiphyImageData? original;

  @JsonKey(name: 'downsized')
  final GiphyImageData? downsized;

  @JsonKey(name: 'downsized_small')
  final GiphyImageData? downsizedSmall;

  @JsonKey(name: 'downsized_medium')
  final GiphyImageData? downsizedMedium;

  @JsonKey(name: 'downsized_large')
  final GiphyImageData? downsizedLarge;

  const GiphyImages({
    this.fixedHeightSmall,
    this.fixedHeight,
    this.fixedWidthSmall,
    this.fixedWidth,
    this.original,
    this.downsized,
    this.downsizedSmall,
    this.downsizedMedium,
    this.downsizedLarge,
  });

  factory GiphyImages.fromJson(Map<String, dynamic> json) =>
      _$GiphyImagesFromJson(json);

  Map<String, dynamic> toJson() => _$GiphyImagesToJson(this);

  @override
  List<Object?> get props => [
    fixedHeightSmall,
    fixedHeight,
    fixedWidthSmall,
    fixedWidth,
    original,
    downsized,
    downsizedSmall,
    downsizedMedium,
    downsizedLarge,
  ];
}
