import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result(T value) = Data<T>;

  const factory Result.none({T? value}) = None<T>;

  const factory Result.loading() = Loading<T>;

  const factory Result.error({Object? error, String? message}) = ErrorDetails<T>;

  const factory Result.exhausted({T? value}) = Exhausted<T>;
}

void noop() {}

extension ResultExtensions<T> on Result<T> {
  bool get canLoadMore {
    return when((_) => true, none: (_) => true, loading: () => false, error: (_, __) => true, exhausted: (_) => false);
  }

  bool get isLoading {
    return maybeWhen((_) => false, loading: () => true, orElse: () => false);
  }

  bool get isExhausted {
    return maybeWhen((_) => false, exhausted: (_) => true, orElse: () => false);
  }

  bool get didError {
    return maybeWhen((_) => false, error: (_, __) => true, orElse: () => false);
  }

  bool get hasValue {
    return maybeWhen((_) => true, orElse: () => false);
  }

  T? get value {
    return maybeWhen((value) => value, orElse: () => null);
  }

  Result combined(Result<T> result) {
    if (this == result) {
      return this;
    } else if (isLoading || result.isLoading) {
      return const Result.loading();
    } else if (isExhausted && result.isExhausted) {
      return const Result.exhausted();
    } else {
      return const Result.none();
    }
  }
}
