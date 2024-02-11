part of 'fcm_cubit.dart';

// Cubit Status
enum FCMStatus { initial, loading, success, failure }

@freezed
class FCMState with _$FCMState {
  const factory FCMState({
    @Default(FCMStatus.initial) FCMStatus status,
    @Default('') String token,
    FCMMessageEvent? event,
    FCMMessageReceived? message,
    @Default('') String errorMessage,
  }) = _FCMState;

  // Constructor
  const FCMState._();

// Status helper
  bool get isInitial => status == FCMStatus.initial;
  bool get isLoading => status == FCMStatus.loading;
  bool get isSuccess => status == FCMStatus.success;
  bool get isFailure => status == FCMStatus.failure;
}
