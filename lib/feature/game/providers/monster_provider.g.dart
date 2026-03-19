// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monster_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Monsters)
final monstersProvider = MonstersProvider._();

final class MonstersProvider
    extends $NotifierProvider<Monsters, List<MonsterModel>> {
  MonstersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monstersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monstersHash();

  @$internal
  @override
  Monsters create() => Monsters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MonsterModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MonsterModel>>(value),
    );
  }
}

String _$monstersHash() => r'6d954a6f1d54d262a5b1e613bfd115e8b11c6103';

abstract class _$Monsters extends $Notifier<List<MonsterModel>> {
  List<MonsterModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<MonsterModel>, List<MonsterModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MonsterModel>, List<MonsterModel>>,
              List<MonsterModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
