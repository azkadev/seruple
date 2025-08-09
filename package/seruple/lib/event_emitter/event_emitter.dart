

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:seruple/uuid/uuid.dart' show generateUuidazkadev;

/// Code By azkadev
class EventEmitterazkadevazkadev {
  /// Code By azkadev
  final Map<String, Map<String, EventEmitterazkadevListenerazkadev>> events = {};

  /// Code By azkadev
  EventEmitterazkadevazkadev();

  /// Code By azkadev
  void emit({
    required String eventName,
    required dynamic value,
  }) {
    for (final element in events.putIfAbsent(eventName, () {
      return {};
    }).values) {
      if (element.is_pause) {
        continue;
      }
      element.onUpdate(value);
    }
  }

  /// Code By azkadev
  EventEmitterazkadevListenerazkadev on({
    required String eventName,
    required FutureOr<dynamic> Function(dynamic update) onCallback,
  }) {
    final Map<String, EventEmitterazkadevListenerazkadev> event_datas = events.putIfAbsent(eventName, () {
      return {};
    });

    final EventEmitterazkadevListenerazkadev eventEmitterListenerGeneralUniverse = EventEmitterazkadevListenerazkadev();
    eventEmitterListenerGeneralUniverse.ensureInitiaLized(
      eventName: eventName,
      eventUniqueId: generateNewUniqueId(event_datas: event_datas),
      onUpdate: onCallback,
      onCancel: (event) {
        event_datas.remove(event.event_unique_id);
        remove(eventName: eventName, uniqueId: event.event_unique_id);
        if (event.isDisposed) {
          return;
        }
        event.isDisposed = true;
        event.dispose();
      },
    );
    event_datas[eventEmitterListenerGeneralUniverse.event_unique_id] = eventEmitterListenerGeneralUniverse;
    return eventEmitterListenerGeneralUniverse;
  }

  /// Code By azkadev
  void remove({
    required String eventName,
    required String uniqueId,
  }) {
    final Map<String, EventEmitterazkadevListenerazkadev> event_datas = events.putIfAbsent(eventName, () {
      return {};
    });
    event_datas.remove(uniqueId);
  }

  /// Code By azkadev

  String generateNewUniqueId({
    required Map<String, EventEmitterazkadevListenerazkadev> event_datas,
  }) {
    while (true) {
      final String new_unique_id = generateUuidazkadev(Random().nextInt(10) + 10, text: "0123456789abcdefghijklmnopqrstuvwxyz-_");
      if (event_datas.containsKey(new_unique_id) == false) {
        return new_unique_id;
      }
    }
  }
}

/// Code By azkadev
class EventEmitterazkadevListenerazkadev {
  /// Code By azkadev
  late final String event_name;

  /// Code By azkadev
  late final String event_unique_id;

  /// Code By azkadev
  late final Function(EventEmitterazkadevListenerazkadev event) onCancel;

  /// Code By azkadev
  late final Function(dynamic data) onUpdate;

  /// Code By azkadev
  bool is_initialized = false;

  /// Code By azkadev
  bool is_cancel = false;

  /// Code By azkadev
  bool is_pause = false;

  /// GeneralUnivetse
  bool isDisposed = false;

  /// Code By azkadev
  EventEmitterazkadevListenerazkadev();

  /// Code By azkadev
  void ensureInitiaLized({
    required String eventName,
    required String eventUniqueId,
    required Function(dynamic data) onUpdate,
    required Function(EventEmitterazkadevListenerazkadev event) onCancel,
  }) {
    if (is_initialized) {
      return;
    }
    event_name = eventName;
    event_unique_id = eventUniqueId;
    this.onUpdate = onUpdate;
    this.onCancel = onCancel;
    is_initialized = true;
  }

  /// Code By azkadev
  void resume() {
    is_pause = false;
  }

  /// Code By azkadev
  void pause() {
    is_pause = true;
  }

  // @override
  //
  /// Code By azkadev
  void dispose() {
    if (isDisposed) {
      return;
    }
    isDisposed = true;
    close();
  }

  /// Code By azkadev
  void close() {
    isDisposed = true;
    cancel();
    return;
  }

  /// Code By azkadev
  bool cancel() {
    if (is_initialized == false) {
      return false;
    }
    isDisposed = true;
    is_cancel = true;
    is_pause = true;
    onCancel(this);
    return true;
  }

  @override
  String toString() {
    return "$event_name $event_unique_id";
  }
}

