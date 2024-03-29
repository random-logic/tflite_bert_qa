import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tflite_bert_qa_method_channel.dart';

abstract class TfliteBertQaPlatform extends PlatformInterface {
  /// Constructs a TfliteBertQaPlatform.
  TfliteBertQaPlatform() : super(token: _token);

  static final Object _token = Object();

  static TfliteBertQaPlatform _instance = MethodChannelTfliteBertQa();

  /// The default instance of [TfliteBertQaPlatform] to use.
  ///
  /// Defaults to [MethodChannelTfliteBertQa].
  static TfliteBertQaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TfliteBertQaPlatform] when
  /// they register themselves.
  static set instance(TfliteBertQaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getAnswer(String context, String question) {
    throw UnimplementedError("getAnswer() has not been implemented.");
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
