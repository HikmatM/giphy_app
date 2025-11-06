import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'giphy_image_data.g.dart';

@JsonSerializable()
class GiphyImageData extends Equatable {
  final String? url;
  final String? width;
  final String? height;
  final String? size;
  final String? mp4;
  final String? mp4Size;
  final String? webp;
  final String? webpSize;

  const GiphyImageData({
    this.url,
    this.width,
    this.height,
    this.size,
    this.mp4,
    this.mp4Size,
    this.webp,
    this.webpSize,
  });

  factory GiphyImageData.fromJson(Map<String, dynamic> json) =>
      _$GiphyImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$GiphyImageDataToJson(this);

  @override
  List<Object?> get props => [
    url,
    width,
    height,
    size,
    mp4,
    mp4Size,
    webp,
    webpSize,
  ];
}
