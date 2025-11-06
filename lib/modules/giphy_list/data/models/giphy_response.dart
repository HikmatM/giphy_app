import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/common/models/giphy_data.dart';
import '../../../../core/common/models/meta.dart';

part 'giphy_response.g.dart';

@JsonSerializable()
class GiphyResponse extends Equatable {
  final List<GiphyData> data;
  final Pagination? pagination;
  final Meta? meta;

  const GiphyResponse({required this.data, this.pagination, this.meta});

  factory GiphyResponse.fromJson(Map<String, dynamic> json) =>
      _$GiphyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GiphyResponseToJson(this);

  @override
  List<Object?> get props => [data, pagination, meta];
}

@JsonSerializable()
class Pagination extends Equatable {
  @JsonKey(name: 'total_count')
  final int totalCount;
  final int count;
  final int offset;

  const Pagination({
    required this.totalCount,
    required this.count,
    required this.offset,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  @override
  List<Object?> get props => [totalCount, count, offset];
}
