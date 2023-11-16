import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_future_provider/data/postal_code.dart';
import 'package:udemy_future_provider/main_logic.dart';

final _logicProvider = Provider<Logic>((ref) => Logic());
final _postalcodeProvider = StateProvider<String>((ref) => '');
AutoDisposeFutureProviderFamily<PostalCode, String> _apiFamilyProvider =
    FutureProvider.autoDispose
        .family<PostalCode, String>((ref, postalcode) async {
      Logic logic = ref.watch(_logicProvider);
      if (!logic.willProceed(postalcode)) {
        // return PostalCode.empty;
      }
      return await logic.getPostalCode(postalcode);
    });

class MainPageVM {
  late final WidgetRef _ref;
  String get postalcode => _ref.watch(_postalcodeProvider);

  AsyncValue<PostalCode> postalCodeWithFamily(String postcode) =>
      _ref.watch(_apiFamilyProvider(postcode));

  void setRef(WidgetRef ref) {
    this._ref = ref;
  }

  void onPostalcodeChanged(String postalcode) {
    _ref.read(_postalcodeProvider.notifier).update((state) => postalcode);
  }
}