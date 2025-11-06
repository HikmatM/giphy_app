import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/common/models/giphy_data.dart';
import '../../../../core/common/models/meta.dart';

part 'giphy_single_response.g.dart';

@JsonSerializable()
class GiphySingleResponse extends Equatable {
  final GiphyData data;
  final Meta? meta;

  const GiphySingleResponse({required this.data, this.meta});

  factory GiphySingleResponse.fromJson(Map<String, dynamic> json) =>
      _$GiphySingleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GiphySingleResponseToJson(this);

  @override
  List<Object?> get props => [data, meta];
}
