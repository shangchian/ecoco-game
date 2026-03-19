import 'package:json_annotation/json_annotation.dart';

part 'carousel_model.g.dart';

@JsonSerializable()
class CarouselModel {
  final String id;
  final String placementKey;
  final String title;
  final String? promotionCode;
  final String mediaType;
  final String mediaUrl;
  final String? fallbackUrl;
  final String actionType;
  final String? actionLink;
  final int sortOrder;
  final DateTime publishedAt;
  final DateTime? expiredAt;

  CarouselModel({
    required this.id,
    required this.placementKey,
    required this.title,
    this.promotionCode,
    required this.mediaType,
    required this.mediaUrl,
    this.fallbackUrl,
    required this.actionType,
    this.actionLink,
    required this.sortOrder,
    required this.publishedAt,
    this.expiredAt,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) =>
      _$CarouselModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselModelToJson(this);
}
