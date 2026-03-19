import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/area_model.dart';

part 'area_provider.g.dart';

@Riverpod(keepAlive: true)
class AreaNotifier extends _$AreaNotifier {
  @override
  Area build() => Area();

  bool _isLoaded = false;

  Future<void> loadFromCSV() async {
    if (_isLoaded) return; // 避免重複載入
    await state.loadFromCSV();
    _isLoaded = true;
  }
}
