import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mayo_flutter_push_notifications/src/models.dart';
import 'package:mayo_flutter_push_notifications/src/push_notifications_repository.dart';

part 'fcm_cubit.freezed.dart';
part 'fcm_state.dart';

class FCMCubit extends Cubit<FCMState> {
  FCMCubit() : super(FCMState());

  final PushNotificationRepository _pushNotificationRepository =
      PushNotificationRepository();

  late StreamSubscription<FCMEvent> _messageReceivedSubscription;

  @override
  Future<void> close() {
    _messageReceivedSubscription.cancel();
    return super.close();
  }

  void init() {
    emit(state.copyWith(status: FCMStatus.loading));

    _messageReceivedSubscription =
        _pushNotificationRepository.initNotifications().listen((event) {
      log('FCM Event: $event');
      if (state.message?.messageId == event.message.messageId) {
        return;
      }

      emit(state.copyWith(
        status: FCMStatus.success,
        event: event.event,
        message: event.message,
      ));
    });
  }

  Future<void> getToken() async {
    final token = await _pushNotificationRepository.getToken();
    emit(state.copyWith(token: token ?? ''));
  }
}
