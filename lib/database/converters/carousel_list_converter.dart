import 'dart:convert';
import 'package:drift/drift.dart';

/// Model class for carousel items in coupon rules
class CarouselItem {
  final String id;
  final String title;
  final String mediaType;
  final String mediaUrl;
  final String? fallbackUrl;
  final int sortOrder;
  final DateTime publishedAt;
  final DateTime? expiredAt;

  const CarouselItem({
    required this.id,
    required this.title,
    required this.mediaType,
    required this.mediaUrl,
    this.fallbackUrl,
    required this.sortOrder,
    required this.publishedAt,
    this.expiredAt,
  });

  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      mediaUrl: json['mediaUrl']?.toString() ?? '',
      fallbackUrl: json['fallbackUrl']?.toString(),
      sortOrder: json['sortOrder'] as int,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      expiredAt: json['expiredAt'] != null
          ? DateTime.parse(json['expiredAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'fallbackUrl': fallbackUrl,
      'sortOrder': sortOrder,
      'publishedAt': publishedAt.toIso8601String(),
      'expiredAt': expiredAt?.toIso8601String(),
    };
  }
}

// Converter for List<CarouselItem> to/from JSON string for Drift
class CarouselListConverter extends TypeConverter<List<CarouselItem>, String> {
  const CarouselListConverter();

  @override
  List<CarouselItem> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> items = json.decode(fromDb);
    return items.map((item) => CarouselItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  String toSql(List<CarouselItem> value) {
    if (value.isEmpty) return '[]';
    return json.encode(value.map((item) => item.toJson()).toList());
  }
}
