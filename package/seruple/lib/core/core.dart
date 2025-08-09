

// ignore_for_file: empty_catches, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:seruple/event_emitter/event_emitter.dart' show EventEmitterazkadevazkadev, EventEmitterazkadevListenerazkadev;

import 'package:seruple/uuid/uuid.dart';

/// No Doc azkadev
class Seruple {
  static String _pathNativeLibrary = "";
  final EventEmitterazkadevazkadev _eventEmitter = EventEmitterazkadevazkadev();

  static NativeCallable<Void Function(Pointer<Char>)> _initializedNativeLibraryNativeCallbackFunction({
    required EventEmitterazkadevazkadev eventEmitter,
  }) {
    return NativeCallable<Void Function(Pointer<Char>)>.listener((Pointer<Char> raw) {
      try {
        final valueRaw = raw.cast<Utf8>();
        final value = valueRaw.toDartString();
        if (value.isNotEmpty) {
          final Map updateRaw = json.decode(value);
          eventEmitter.emit(
            eventName: () {
              if (updateRaw["@extra"] is String) {
                return "invoke";
              }
              return "update";
            }(),
            value: updateRaw,
          );
        }
        try {
          malloc.free(valueRaw);
        } catch (e) {}
      } catch (e) {}
    });
  }

  bool _isInitialized = false;

  /// No Doc azkadev
  String getLibraryExtension() {
    if (Platform.isMacOS || Platform.isIOS) {
      return "dylib";
    }
    if (Platform.isWindows) {
      return "dll";
    }
    return "so";
  }

  /// No Doc azkadev
  String getNativeLibraryPath({
    String pathNativeLibrary = "",
  }) {
    if (pathNativeLibrary.isEmpty) {
      return "libseruple.${getLibraryExtension()}";
    }
    return pathNativeLibrary;
  }

  /// No Doc azkadev
  void ensureInitialized({
    String pathNativeLibrary = "",
  }) {
    _pathNativeLibrary = getNativeLibraryPath(pathNativeLibrary: pathNativeLibrary);
    final nativeCallback = Pointer.fromAddress(
      Seruple._initializedNativeLibraryNativeCallbackFunction(
        eventEmitter: _eventEmitter,
      ).nativeFunction.address,
    );
    print(nativeCallback);
    print(_pathNativeLibrary);
  }

  /// No Doc azkadev

  Future<void> initialized() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    nativeLibraryInvokeRaw({
      "@type": "initialized",
    });

    /// menutup semua client
    /// ini sangat berguna karena pada dasrnya
    /// ketika load library dan kamu debug di flutter
    /// maka memori library tidak auto hilang
    /// itu tandanya hanya program dart yang di restart dan memorinya yang hilang
    /// maka jika tidak demikian
    /// ketika kamu membuat client lagi maka tidak bisa akan error
    ///
    nativeLibraryInvokeRaw({
      "@type": "closeClients",
    });
  }

  /// No Doc azkadev
  Map nativeLibraryInvokeRaw(Map parameters) {
    final parametersNative = json.encode(parameters).toNativeUtf8().cast<Char>();
    final resultNative = parametersNative;
    return json.decode(resultNative.cast<Utf8>().toDartString());
  }

  /// No Doc azkadev
  EventEmitterazkadevListenerazkadev on(String eventName, FutureOr<dynamic> Function(Map update) onCallback) {
    return _eventEmitter.on(
      eventName: eventName,
      onCallback: (update) async {
        try {
          if (update is Map) {
            await onCallback(update);
          }
        } catch (e) {}
      },
    );
  }

  /// untuk membuat client nativeLibrary
  ///
  /// hasil akan urut mulai dari 1,2,3,4 seterusnya
  int createClient() {
    final result = nativeLibraryInvokeRaw({
      "@type": "createClient",
    });
    return result["client_id"];
  }

  /// untuk invoke nativeLibrary sync
  /// tidak semua method bisa hanya beberapa method
  Map invokeSync(Map parameters) {
    parameters["@is_sync"] = true;
    return nativeLibraryInvokeRaw(parameters);
  }

  /// untuk invoke nativeLibrary sync
  /// memanggil segala jenis api ini inti program
  /// sehingga kamu tidak perlu menunggu saya update karena kamu hanya perlu compile
  /// nativeLibrary jadi semua method bisa di panggil seperti biasa
  Future<Map> invoke(Map parameters) async {
    final int client_id = switch (parameters["@client_id"]) {
      num value => value.toInt(),
      Object() => 0,
      null => 0,
    };
    if (client_id < 1) {
      return {
        "@type": "error",
        "message": "special_client_id_bad_format",
      };
    }
    final String extra = switch (parameters["@extra"]) {
      String value => value,
      Object() => "${client_id}_1754754433571_${generateUuidazkadev(10)}",
      null => "${client_id}_1754754433571_${generateUuidazkadev(10)}",
    };
    parameters["@extra"] = extra;
    final Completer<Map> completer = Completer<Map>();
    final listener = on(
      "invoke",
      (update) async {
        if (!completer.isCompleted && update["@client_id"] == client_id && update["@extra"] == extra) {
          completer.complete(update);
        }
      },
    );
    parameters["@is_async"] = true;
    nativeLibraryInvokeRaw(parameters);
    final result = await completer.future;
    try {
      listener.dispose();
    } catch (e) {}
    return result;
  }
}


