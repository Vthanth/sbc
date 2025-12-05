// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Result<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<T, $Res> {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) then) =
      _$ResultCopyWithImpl<T, $Res, Result<T>>;
}

/// @nodoc
class _$ResultCopyWithImpl<T, $Res, $Val extends Result<T>>
    implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DataImplCopyWith<T, $Res> {
  factory _$$DataImplCopyWith(
    _$DataImpl<T> value,
    $Res Function(_$DataImpl<T>) then,
  ) = __$$DataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$DataImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$DataImpl<T>>
    implements _$$DataImplCopyWith<T, $Res> {
  __$$DataImplCopyWithImpl(
    _$DataImpl<T> _value,
    $Res Function(_$DataImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = freezed}) {
    return _then(
      _$DataImpl<T>(
        freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                as T,
      ),
    );
  }
}

/// @nodoc

class _$DataImpl<T> with DiagnosticableTreeMixin implements Data<T> {
  const _$DataImpl(this.value);

  @override
  final T value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      __$$DataImplCopyWithImpl<T, _$DataImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) {
    return $default(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) {
    return $default?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Data<T> implements Result<T> {
  const factory Data(final T value) = _$DataImpl<T>;

  T get value;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoneImplCopyWith<T, $Res> {
  factory _$$NoneImplCopyWith(
    _$NoneImpl<T> value,
    $Res Function(_$NoneImpl<T>) then,
  ) = __$$NoneImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? value});
}

/// @nodoc
class __$$NoneImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$NoneImpl<T>>
    implements _$$NoneImplCopyWith<T, $Res> {
  __$$NoneImplCopyWithImpl(
    _$NoneImpl<T> _value,
    $Res Function(_$NoneImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = freezed}) {
    return _then(
      _$NoneImpl<T>(
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as T?,
      ),
    );
  }
}

/// @nodoc

class _$NoneImpl<T> with DiagnosticableTreeMixin implements None<T> {
  const _$NoneImpl({this.value});

  @override
  final T? value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.none(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.none'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoneImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoneImplCopyWith<T, _$NoneImpl<T>> get copyWith =>
      __$$NoneImplCopyWithImpl<T, _$NoneImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) {
    return none(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) {
    return none?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class None<T> implements Result<T> {
  const factory None({final T? value}) = _$NoneImpl<T>;

  T? get value;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoneImplCopyWith<T, _$NoneImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl<T> value,
    $Res Function(_$LoadingImpl<T>) then,
  ) = __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl<T> _value,
    $Res Function(_$LoadingImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl<T> with DiagnosticableTreeMixin implements Loading<T> {
  const _$LoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'Result<$T>.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements Result<T> {
  const factory Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$ErrorDetailsImplCopyWith<T, $Res> {
  factory _$$ErrorDetailsImplCopyWith(
    _$ErrorDetailsImpl<T> value,
    $Res Function(_$ErrorDetailsImpl<T>) then,
  ) = __$$ErrorDetailsImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Object? error, String? message});
}

/// @nodoc
class __$$ErrorDetailsImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$ErrorDetailsImpl<T>>
    implements _$$ErrorDetailsImplCopyWith<T, $Res> {
  __$$ErrorDetailsImplCopyWithImpl(
    _$ErrorDetailsImpl<T> _value,
    $Res Function(_$ErrorDetailsImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = freezed, Object? message = freezed}) {
    return _then(
      _$ErrorDetailsImpl<T>(
        error: freezed == error ? _value.error : error,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$ErrorDetailsImpl<T>
    with DiagnosticableTreeMixin
    implements ErrorDetails<T> {
  const _$ErrorDetailsImpl({this.error, this.message});

  @override
  final Object? error;
  @override
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.error(error: $error, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.error'))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorDetailsImpl<T> &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(error),
    message,
  );

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorDetailsImplCopyWith<T, _$ErrorDetailsImpl<T>> get copyWith =>
      __$$ErrorDetailsImplCopyWithImpl<T, _$ErrorDetailsImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) {
    return error(this.error, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) {
    return error?.call(this.error, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorDetails<T> implements Result<T> {
  const factory ErrorDetails({final Object? error, final String? message}) =
      _$ErrorDetailsImpl<T>;

  Object? get error;
  String? get message;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorDetailsImplCopyWith<T, _$ErrorDetailsImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExhaustedImplCopyWith<T, $Res> {
  factory _$$ExhaustedImplCopyWith(
    _$ExhaustedImpl<T> value,
    $Res Function(_$ExhaustedImpl<T>) then,
  ) = __$$ExhaustedImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? value});
}

/// @nodoc
class __$$ExhaustedImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$ExhaustedImpl<T>>
    implements _$$ExhaustedImplCopyWith<T, $Res> {
  __$$ExhaustedImplCopyWithImpl(
    _$ExhaustedImpl<T> _value,
    $Res Function(_$ExhaustedImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = freezed}) {
    return _then(
      _$ExhaustedImpl<T>(
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as T?,
      ),
    );
  }
}

/// @nodoc

class _$ExhaustedImpl<T> with DiagnosticableTreeMixin implements Exhausted<T> {
  const _$ExhaustedImpl({this.value});

  @override
  final T? value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.exhausted(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.exhausted'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExhaustedImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExhaustedImplCopyWith<T, _$ExhaustedImpl<T>> get copyWith =>
      __$$ExhaustedImplCopyWithImpl<T, _$ExhaustedImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T value) $default, {
    required TResult Function(T? value) none,
    required TResult Function() loading,
    required TResult Function(Object? error, String? message) error,
    required TResult Function(T? value) exhausted,
  }) {
    return exhausted(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(T value)? $default, {
    TResult? Function(T? value)? none,
    TResult? Function()? loading,
    TResult? Function(Object? error, String? message)? error,
    TResult? Function(T? value)? exhausted,
  }) {
    return exhausted?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T value)? $default, {
    TResult Function(T? value)? none,
    TResult Function()? loading,
    TResult Function(Object? error, String? message)? error,
    TResult Function(T? value)? exhausted,
    required TResult orElse(),
  }) {
    if (exhausted != null) {
      return exhausted(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data<T> value) $default, {
    required TResult Function(None<T> value) none,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(ErrorDetails<T> value) error,
    required TResult Function(Exhausted<T> value) exhausted,
  }) {
    return exhausted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data<T> value)? $default, {
    TResult? Function(None<T> value)? none,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(ErrorDetails<T> value)? error,
    TResult? Function(Exhausted<T> value)? exhausted,
  }) {
    return exhausted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data<T> value)? $default, {
    TResult Function(None<T> value)? none,
    TResult Function(Loading<T> value)? loading,
    TResult Function(ErrorDetails<T> value)? error,
    TResult Function(Exhausted<T> value)? exhausted,
    required TResult orElse(),
  }) {
    if (exhausted != null) {
      return exhausted(this);
    }
    return orElse();
  }
}

abstract class Exhausted<T> implements Result<T> {
  const factory Exhausted({final T? value}) = _$ExhaustedImpl<T>;

  T? get value;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExhaustedImplCopyWith<T, _$ExhaustedImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
