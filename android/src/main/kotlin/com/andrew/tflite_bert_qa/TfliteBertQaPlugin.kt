package com.andrew.tflite_bert_qa

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** TfliteBertQaPlugin */
class TfliteBertQaPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var context: Context
  private lateinit var channel: MethodChannel
  private lateinit var answerer: BertQaHelper

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tflite_bert_qa")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    answerer = BertQaHelper(context)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "getAnswer" -> {
        val contextOfTheQuestion = call.argument<String>("contextOfTheQuestion")
        val questionToAsk = call.argument<String>("questionToAsk")

        if (contextOfTheQuestion == null) {
          result.error("INVALID_ARGUMENTS", "contextOfTheQuestion is missing", null)
        } else if (questionToAsk == null) {
          result.error("INVALID_ARGUMENTS", "questionToAsk is missing", null)
        } else {
          val answer = answerer.answer(contextOfTheQuestion, questionToAsk)
          result.success(answer)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
