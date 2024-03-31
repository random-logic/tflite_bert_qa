import Flutter
import UIKit

public class TfliteBertQaPlugin: NSObject, FlutterPlugin {
    var answerer: BertQAHandler?
  
    override init() {
        super.init()

        do {
            let modelPath = self.path(of: MobileBERT.model)
            let vocabPath = self.path(of: MobileBERT.vocabulary)
            self.answerer = try BertQAHandler(modelPath: modelPath, vocabPath: vocabPath)
        }
        catch {
            NSLog("Error: %@", error.localizedDescription)
        }
    }
    
    func path(of file: File) -> String {
        guard let res = Bundle(for: type(of: self)).path(forResource: file.name, ofType: file.ext) else {
            fatalError("Cannot find \(file.name).\(file.ext)")
        }
        return res
    }
        
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "tflite_bert_qa", binaryMessenger: registrar.messenger())
      let instance = TfliteBertQaPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAnswer":
        guard let arguments = call.arguments as? [String: Any],
              let context = arguments["contextOfTheQuestion"] as? String,
              let question = arguments["questionToAsk"] as? String else {
            result(FlutterError(code: "argument_error", message: "Invalid arguments", details: nil))
            return
        }
        let res = answerer!.run(query: question, content: context)
        let ans = res?.answer.text.value
        result(ans)
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
