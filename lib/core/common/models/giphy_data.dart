import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'giphy_images.dart';

part 'giphy_data.g.dart';

@JsonSerializable()
class GiphyData extends Equatable {
  final String id;
  final String title;
  final String type;
  final String? rating;
  final String? username;
  final String? source;
  final String? url;
  final String? embedUrl;
  final GiphyImages images;

  const GiphyData({
    required this.id,
    required this.title,
    required this.type,
    this.rating,
    this.username,
    this.source,
    this.url,
    this.embedUrl,
    required this.images,
  });

  factory GiphyData.fromJson(Map<String, dynamic> json) =>
      _$GiphyDataFromJson(json);

  Map<String, dynamic> toJson() => _$GiphyDataToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    rating,
    username,
    source,
    url,
    embedUrl,
    images,
  ];
}
