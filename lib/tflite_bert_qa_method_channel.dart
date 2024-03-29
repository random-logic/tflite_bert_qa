import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tflite_bert_qa_platform_interface.dart';

/// An implementation of [TfliteBertQaPlatform] that uses method channels.
class MethodChannelTfliteBertQa extends TfliteBertQaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tflite_bert_qa');

  @override
  Future<String?> getAnswer(String context, String question) async {
    return await methodChannel.invokeMethod<String?>('getAnswer', {
      "contextOfTheQuestion": context,
      "questionToAsk": question
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
