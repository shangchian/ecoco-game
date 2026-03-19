// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bio_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BioAuthData _$BioAuthDataFromJson(Map<String, dynamic> json) => BioAuthData(
  phone: json['phone'] as String? ?? '',
  password: json['password'] as String? ?? '',
);

Map<String, dynamic> _$BioAuthDataToJson(BioAuthData instance) =>
    <String, dynamic>{'phone': instance.phone, 'password': instance.password};
