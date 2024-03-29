
import 'tflite_bert_qa_platform_interface.dart';

class TfliteBertQa {
  Future<String?> getAnswer(String context, String question) {
    return TfliteBertQaPlatform.instance.getAnswer(context, question);
  }

  Future<String?> getPlatformVersion() {
    return TfliteBertQaPlatform.instance.getPlatformVersion();
  }
}
