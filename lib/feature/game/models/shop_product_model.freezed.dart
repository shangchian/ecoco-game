// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShopProductModel {

 String get id; String get title; String get description; ProductCurrencyType get currencyType; int? get ecocoPointCost;// Cost in ECOCO points (if applicable)
 String? get iapPriceString;// Formatted localized price e.g. "NT$30" (if applicable)
 int get goldReward;// Amount of game gold rewarded upon purchase
 bool get isAvailable;
/// Create a copy of ShopProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopProductModelCopyWith<ShopProductModel> get copyWith => _$ShopProductModelCopyWithImpl<ShopProductModel>(this as ShopProductModel, _$identity);

  /// Serializes this ShopProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.currencyType, currencyType) || other.currencyType == currencyType)&&(identical(other.ecocoPointCost, ecocoPointCost) || other.ecocoPointCost == ecocoPointCost)&&(identical(other.iapPriceString, iapPriceString) || other.iapPriceString == iapPriceString)&&(identical(other.goldReward, goldReward) || other.goldReward == goldReward)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,currencyType,ecocoPointCost,iapPriceString,goldReward,isAvailable);

@override
String toString() {
  return 'ShopProductModel(id: $id, title: $title, description: $description, currencyType: $currencyType, ecocoPointCost: $ecocoPointCost, iapPriceString: $iapPriceString, goldReward: $goldReward, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $ShopProductModelCopyWith<$Res>  {
  factory $ShopProductModelCopyWith(ShopProductModel value, $Res Function(ShopProductModel) _then) = _$ShopProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, ProductCurrencyType currencyType, int? ecocoPointCost, String? iapPriceString, int goldReward, bool isAvailable
});




}
/// @nodoc
class _$ShopProductModelCopyWithImpl<$Res>
    implements $ShopProductModelCopyWith<$Res> {
  _$ShopProductModelCopyWithImpl(this._self, this._then);

  final ShopProductModel _self;
  final $Res Function(ShopProductModel) _then;

/// Create a copy of ShopProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? currencyType = null,Object? ecocoPointCost = freezed,Object? iapPriceString = freezed,Object? goldReward = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,currencyType: null == currencyType ? _self.currencyType : currencyType // ignore: cast_nullable_to_non_nullable
as ProductCurrencyType,ecocoPointCost: freezed == ecocoPointCost ? _self.ecocoPointCost : ecocoPointCost // ignore: cast_nullable_to_non_nullable
as int?,iapPriceString: freezed == iapPriceString ? _self.iapPriceString : iapPriceString // ignore: cast_nullable_to_non_nullable
as String?,goldReward: null == goldReward ? _self.goldReward : goldReward // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopProductModel].
extension ShopProductModelPatterns on ShopProductModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopProductModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ShopProductModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShopProductModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  ProductCurrencyType currencyType,  int? ecocoPointCost,  String? iapPriceString,  int goldReward,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopProductModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.currencyType,_that.ecocoPointCost,_that.iapPriceString,_that.goldReward,_that.isAvailable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  ProductCurrencyType currencyType,  int? ecocoPointCost,  String? iapPriceString,  int goldReward,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _ShopProductModel():
return $default(_that.id,_that.title,_that.description,_that.currencyType,_that.ecocoPointCost,_that.iapPriceString,_that.goldReward,_that.isAvailable);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  ProductCurrencyType currencyType,  int? ecocoPointCost,  String? iapPriceString,  int goldReward,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ShopProductModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.currencyType,_that.ecocoPointCost,_that.iapPriceString,_that.goldReward,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShopProductModel implements ShopProductModel {
  const _ShopProductModel({required this.id, required this.title, required this.description, required this.currencyType, this.ecocoPointCost, this.iapPriceString, required this.goldReward, this.isAvailable = false});
  factory _ShopProductModel.fromJson(Map<String, dynamic> json) => _$ShopProductModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  ProductCurrencyType currencyType;
@override final  int? ecocoPointCost;
// Cost in ECOCO points (if applicable)
@override final  String? iapPriceString;
// Formatted localized price e.g. "NT$30" (if applicable)
@override final  int goldReward;
// Amount of game gold rewarded upon purchase
@override@JsonKey() final  bool isAvailable;

/// Create a copy of ShopProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopProductModelCopyWith<_ShopProductModel> get copyWith => __$ShopProductModelCopyWithImpl<_ShopProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.currencyType, currencyType) || other.currencyType == currencyType)&&(identical(other.ecocoPointCost, ecocoPointCost) || other.ecocoPointCost == ecocoPointCost)&&(identical(other.iapPriceString, iapPriceString) || other.iapPriceString == iapPriceString)&&(identical(other.goldReward, goldReward) || other.goldReward == goldReward)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,currencyType,ecocoPointCost,iapPriceString,goldReward,isAvailable);

@override
String toString() {
  return 'ShopProductModel(id: $id, title: $title, description: $description, currencyType: $currencyType, ecocoPointCost: $ecocoPointCost, iapPriceString: $iapPriceString, goldReward: $goldReward, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$ShopProductModelCopyWith<$Res> implements $ShopProductModelCopyWith<$Res> {
  factory _$ShopProductModelCopyWith(_ShopProductModel value, $Res Function(_ShopProductModel) _then) = __$ShopProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, ProductCurrencyType currencyType, int? ecocoPointCost, String? iapPriceString, int goldReward, bool isAvailable
});




}
/// @nodoc
class __$ShopProductModelCopyWithImpl<$Res>
    implements _$ShopProductModelCopyWith<$Res> {
  __$ShopProductModelCopyWithImpl(this._self, this._then);

  final _ShopProductModel _self;
  final $Res Function(_ShopProductModel) _then;

/// Create a copy of ShopProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? currencyType = null,Object? ecocoPointCost = freezed,Object? iapPriceString = freezed,Object? goldReward = null,Object? isAvailable = null,}) {
  return _then(_ShopProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,currencyType: null == currencyType ? _self.currencyType : currencyType // ignore: cast_nullable_to_non_nullable
as ProductCurrencyType,ecocoPointCost: freezed == ecocoPointCost ? _self.ecocoPointCost : ecocoPointCost // ignore: cast_nullable_to_non_nullable
as int?,iapPriceString: freezed == iapPriceString ? _self.iapPriceString : iapPriceString // ignore: cast_nullable_to_non_nullable
as String?,goldReward: null == goldReward ? _self.goldReward : goldReward // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
