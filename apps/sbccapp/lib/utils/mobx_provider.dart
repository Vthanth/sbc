import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as pr;
import 'package:provider/provider.dart';

class MobxProvider<T extends Disposable?> extends pr.Provider<T> {
  static void _dispose(BuildContext context, Disposable? store) {
    store?.dispose();
  }

  MobxProvider({super.key, required super.create, super.lazy, super.child}) : super(dispose: _dispose);

  MobxProvider.value({super.key, required super.value, super.updateShouldNotify, super.child}) : super.value();
}

mixin Disposable {
  void dispose() {}
}

extension WatchOrNull on BuildContext {
  T? watchOrNull<T>() {
    try {
      return watch<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  T? readOrNull<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }
}
