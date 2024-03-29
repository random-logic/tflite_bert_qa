import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_bert_qa/tflite_bert_qa.dart';
import 'package:tflite_bert_qa/tflite_bert_qa_platform_interface.dart';
import 'package:tflite_bert_qa/tflite_bert_qa_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTfliteBertQaPlatform
    with MockPlatformInterfaceMixin
    implements TfliteBertQaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getAnswer(String context, String question) async {
    return "done";
  }
}

void main() {
  final TfliteBertQaPlatform initialPlatform = TfliteBertQaPlatform.instance;

  test('$MethodChannelTfliteBertQa is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTfliteBertQa>());
  });

  test('getPlatformVersion', () async {
    TfliteBertQa tfliteBertQaPlugin = TfliteBertQa();
    MockTfliteBertQaPlatform fakePlatform = MockTfliteBertQaPlatform();
    TfliteBertQaPlatform.instance = fakePlatform;

    expect(await tfliteBertQaPlugin.getPlatformVersion(), '42');
  });
}
