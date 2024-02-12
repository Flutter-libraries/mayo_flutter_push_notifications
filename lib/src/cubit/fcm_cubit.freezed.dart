// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FCMState {
  FCMStatus get status => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  FCMMessageEvent? get event => throw _privateConstructorUsedError;
  FCMMessageReceived? get message => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FCMStateCopyWith<FCMState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMStateCopyWith<$Res> {
  factory $FCMStateCopyWith(FCMState value, $Res Function(FCMState) then) =
      _$FCMStateCopyWithImpl<$Res, FCMState>;
  @useResult
  $Res call(
      {FCMStatus status,
      String token,
      FCMMessageEvent? event,
      FCMMessageReceived? message,
      String errorMessage});
}

/// @nodoc
class _$FCMStateCopyWithImpl<$Res, $Val extends FCMState>
    implements $FCMStateCopyWith<$Res> {
  _$FCMStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? token = null,
    Object? event = freezed,
    Object? message = freezed,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FCMStatus,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as FCMMessageEvent?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as FCMMessageReceived?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMStateImplCopyWith<$Res>
    implements $FCMStateCopyWith<$Res> {
  factory _$$FCMStateImplCopyWith(
          _$FCMStateImpl value, $Res Function(_$FCMStateImpl) then) =
      __$$FCMStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FCMStatus status,
      String token,
      FCMMessageEvent? event,
      FCMMessageReceived? message,
      String errorMessage});
}

/// @nodoc
class __$$FCMStateImplCopyWithImpl<$Res>
    extends _$FCMStateCopyWithImpl<$Res, _$FCMStateImpl>
    implements _$$FCMStateImplCopyWith<$Res> {
  __$$FCMStateImplCopyWithImpl(
      _$FCMStateImpl _value, $Res Function(_$FCMStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? token = null,
    Object? event = freezed,
    Object? message = freezed,
    Object? errorMessage = null,
  }) {
    return _then(_$FCMStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FCMStatus,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as FCMMessageEvent?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as FCMMessageReceived?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FCMStateImpl extends _FCMState {
  const _$FCMStateImpl(
      {this.status = FCMStatus.initial,
      this.token = '',
      this.event,
      this.message,
      this.errorMessage = ''})
      : super._();

  @override
  @JsonKey()
  final FCMStatus status;
  @override
  @JsonKey()
  final String token;
  @override
  final FCMMessageEvent? event;
  @override
  final FCMMessageReceived? message;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'FCMState(status: $status, token: $token, event: $event, message: $message, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, token, event, message, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMStateImplCopyWith<_$FCMStateImpl> get copyWith =>
      __$$FCMStateImplCopyWithImpl<_$FCMStateImpl>(this, _$identity);
}

abstract class _FCMState extends FCMState {
  const factory _FCMState(
      {final FCMStatus status,
      final String token,
      final FCMMessageEvent? event,
      final FCMMessageReceived? message,
      final String errorMessage}) = _$FCMStateImpl;
  const _FCMState._() : super._();

  @override
  FCMStatus get status;
  @override
  String get token;
  @override
  FCMMessageEvent? get event;
  @override
  FCMMessageReceived? get message;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$FCMStateImplCopyWith<_$FCMStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
