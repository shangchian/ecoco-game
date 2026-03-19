// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameWalletModel {

 int get gameGold;// 遊戲金幣
 int get ecocoPoints;// ECOCO 點數 (同步自原本會員系統)
 DateTime? get lastSyncedAt;
/// Create a copy of GameWalletModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameWalletModelCopyWith<GameWalletModel> get copyWith => _$GameWalletModelCopyWithImpl<GameWalletModel>(this as GameWalletModel, _$identity);

  /// Serializes this GameWalletModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameWalletModel&&(identical(other.gameGold, gameGold) || other.gameGold == gameGold)&&(identical(other.ecocoPoints, ecocoPoints) || other.ecocoPoints == ecocoPoints)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameGold,ecocoPoints,lastSyncedAt);

@override
String toString() {
  return 'GameWalletModel(gameGold: $gameGold, ecocoPoints: $ecocoPoints, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class $GameWalletModelCopyWith<$Res>  {
  factory $GameWalletModelCopyWith(GameWalletModel value, $Res Function(GameWalletModel) _then) = _$GameWalletModelCopyWithImpl;
@useResult
$Res call({
 int gameGold, int ecocoPoints, DateTime? lastSyncedAt
});




}
/// @nodoc
class _$GameWalletModelCopyWithImpl<$Res>
    implements $GameWalletModelCopyWith<$Res> {
  _$GameWalletModelCopyWithImpl(this._self, this._then);

  final GameWalletModel _self;
  final $Res Function(GameWalletModel) _then;

/// Create a copy of GameWalletModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameGold = null,Object? ecocoPoints = null,Object? lastSyncedAt = freezed,}) {
  return _then(_self.copyWith(
gameGold: null == gameGold ? _self.gameGold : gameGold // ignore: cast_nullable_to_non_nullable
as int,ecocoPoints: null == ecocoPoints ? _self.ecocoPoints : ecocoPoints // ignore: cast_nullable_to_non_nullable
as int,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameWalletModel].
extension GameWalletModelPatterns on GameWalletModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameWalletModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameWalletModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameWalletModel value)  $default,){
final _that = this;
switch (_that) {
case _GameWalletModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameWalletModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameWalletModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int gameGold,  int ecocoPoints,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameWalletModel() when $default != null:
return $default(_that.gameGold,_that.ecocoPoints,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int gameGold,  int ecocoPoints,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _GameWalletModel():
return $default(_that.gameGold,_that.ecocoPoints,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int gameGold,  int ecocoPoints,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _GameWalletModel() when $default != null:
return $default(_that.gameGold,_that.ecocoPoints,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameWalletModel implements GameWalletModel {
  const _GameWalletModel({this.gameGold = 0, this.ecocoPoints = 0, this.lastSyncedAt});
  factory _GameWalletModel.fromJson(Map<String, dynamic> json) => _$GameWalletModelFromJson(json);

@override@JsonKey() final  int gameGold;
// 遊戲金幣
@override@JsonKey() final  int ecocoPoints;
// ECOCO 點數 (同步自原本會員系統)
@override final  DateTime? lastSyncedAt;

/// Create a copy of GameWalletModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameWalletModelCopyWith<_GameWalletModel> get copyWith => __$GameWalletModelCopyWithImpl<_GameWalletModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameWalletModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameWalletModel&&(identical(other.gameGold, gameGold) || other.gameGold == gameGold)&&(identical(other.ecocoPoints, ecocoPoints) || other.ecocoPoints == ecocoPoints)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameGold,ecocoPoints,lastSyncedAt);

@override
String toString() {
  return 'GameWalletModel(gameGold: $gameGold, ecocoPoints: $ecocoPoints, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$GameWalletModelCopyWith<$Res> implements $GameWalletModelCopyWith<$Res> {
  factory _$GameWalletModelCopyWith(_GameWalletModel value, $Res Function(_GameWalletModel) _then) = __$GameWalletModelCopyWithImpl;
@override @useResult
$Res call({
 int gameGold, int ecocoPoints, DateTime? lastSyncedAt
});




}
/// @nodoc
class __$GameWalletModelCopyWithImpl<$Res>
    implements _$GameWalletModelCopyWith<$Res> {
  __$GameWalletModelCopyWithImpl(this._self, this._then);

  final _GameWalletModel _self;
  final $Res Function(_GameWalletModel) _then;

/// Create a copy of GameWalletModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameGold = null,Object? ecocoPoints = null,Object? lastSyncedAt = freezed,}) {
  return _then(_GameWalletModel(
gameGold: null == gameGold ? _self.gameGold : gameGold // ignore: cast_nullable_to_non_nullable
as int,ecocoPoints: null == ecocoPoints ? _self.ecocoPoints : ecocoPoints // ignore: cast_nullable_to_non_nullable
as int,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
