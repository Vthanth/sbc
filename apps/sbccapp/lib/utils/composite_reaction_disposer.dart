import 'package:mobx/mobx.dart';

class CompositeReactionDisposer {
  final List<ReactionDisposer> _disposer = <ReactionDisposer>[];

  void add(ReactionDisposer disposer) {
    _disposer.add(disposer);
  }

  void dispose() {
    for (var element in _disposer) {
      element();
    }
  }
}

extension ReactionDisposerExtension on ReactionDisposer {
  void disposeWith(CompositeReactionDisposer disposers) {
    disposers.add(this);
  }
}
