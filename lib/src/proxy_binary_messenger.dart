import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// A proxy binary messenger that implements the [BinaryMessenger] interface.
///
/// This class is responsible for handling communication between the Flutter framework
/// and the platform-specific binary messenger. It allows for sending and receiving
/// binary messages between the Flutter app and the platform.
class ProxyBinaryMessenger implements BinaryMessenger {
  /// Creates a new instance of [ProxyBinaryMessenger].
  ///
  /// The [suffix] parameter is used to specify a suffix for the channel names.
  /// The [binaryMessenger] parameter is optional and defaults to the default binary messenger provided by the [ServicesBinding].
  ProxyBinaryMessenger(
      {required String suffix, BinaryMessenger? binaryMessenger})
      : _suffix = suffix,
        _binaryMessenger =
            binaryMessenger ?? ServicesBinding.instance.defaultBinaryMessenger;

  final BinaryMessenger _binaryMessenger;
  final String _suffix;

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    ui.PlatformMessageResponseCallback? callback,
  ) {
    return _binaryMessenger.handlePlatformMessage(
      '$channel$_suffix',
      data,
      callback,
    );
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? data) {
    return _binaryMessenger.send('$channel$_suffix', data);
  }

  @override
  void setMessageHandler(
    String channel,
    MessageHandler? handler,
  ) {
    _binaryMessenger.setMessageHandler('$channel$_suffix', handler);
  }
}
