import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_wallet_model.freezed.dart';
part 'game_wallet_model.g.dart';

@freezed
abstract class GameWalletModel with _$GameWalletModel {
  const factory GameWalletModel({
    @Default(0) int gameGold, // 遊戲金幣
    @Default(0) int ecocoPoints, // ECOCO 點數 (同步自原本會員系統)
    DateTime? lastSyncedAt, // 最後與伺服器同步的時間
  }) = _GameWalletModel;

  factory GameWalletModel.fromJson(Map<String, dynamic> json) => _$GameWalletModelFromJson(json);
}
