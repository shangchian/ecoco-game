import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable(includeIfNull: true)
class BannerModel {
  final String id;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String? title;
  @JsonKey(name: "link_url")
  final String? linkUrl;
  @JsonKey(name: "display_order", defaultValue: 0)
  final int displayOrder;
  @JsonKey(name: "is_active", defaultValue: true)
  final bool isActive;
  @JsonKey(name: "start_date")
  final DateTime? startDate;
  @JsonKey(name: "end_date")
  final DateTime? endDate;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.linkUrl,
    required this.displayOrder,
    required this.isActive,
    this.startDate,
    this.endDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  // Mock data for testing
  static List<BannerModel> getMockBanners() {
    return [
      BannerModel(
        id: '1',
        imageUrl: 'assets/images/banner_1000.png',
        title: '1000站',
        linkUrl: null,
        displayOrder: 1,
        isActive: true,
      ),
      BannerModel(
        id: '2',
        imageUrl: 'assets/images/banner_promotion.png',
        title: '最新優惠活動',
        linkUrl: null,
        displayOrder: 2,
        isActive: true,
      ),
      BannerModel(
        id: '3',
        imageUrl: 'assets/images/banner_recycle.png',
        title: '回收再生',
        linkUrl: null,
        displayOrder: 3,
        isActive: true,
      ),
    ];
  }
}
