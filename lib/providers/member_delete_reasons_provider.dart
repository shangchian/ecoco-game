import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/member_delete_reason_model.dart';
import '/repositories/delete_reasons_repository.dart';

part 'member_delete_reasons_provider.g.dart';

@Riverpod(keepAlive: true)
class MemberDeleteReasons extends _$MemberDeleteReasons {
  @override
  DeleteReasonsResponse? build() {
    return null;
  }

  Future<void> fetchReasons() async {
    final repository = DeleteReasonsRepository();
    final reasons = await repository.getDeleteReasons();
    state = DeleteReasonsResponse(result: reasons);
  }
}
