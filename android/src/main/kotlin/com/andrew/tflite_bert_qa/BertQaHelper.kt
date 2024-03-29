/*
 * Copyright 2022 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.andrew.tflite_bert_qa

import android.content.Context
import android.util.Log
import org.tensorflow.lite.gpu.CompatibilityList
import org.tensorflow.lite.task.core.BaseOptions
import org.tensorflow.lite.task.text.qa.BertQuestionAnswerer
import org.tensorflow.lite.task.text.qa.BertQuestionAnswerer.BertQuestionAnswererOptions
import java.lang.IllegalStateException

class GPUNotSupportedException(message: String) : Exception(message)
class ModelInitializationException(message: String) : Exception(message)

class BertQaHelper(
    val context: Context,
    var numThreads: Int = 2,
    var currentDelegate: Int = 0
) {

    private var bertQuestionAnswerer: BertQuestionAnswerer? = null

    init {
        setupBertQuestionAnswerer()
    }

    fun clearBertQuestionAnswerer() {
        bertQuestionAnswerer = null
    }

    private fun setupBertQuestionAnswerer() {
        val baseOptionsBuilder = BaseOptions.builder().setNumThreads(numThreads)

        when (currentDelegate) {
            DELEGATE_CPU -> {
                // Default
            }
            DELEGATE_GPU -> {
                if (CompatibilityList().isDelegateSupportedOnThisDevice) {
                    baseOptionsBuilder.useGpu()
                } else {
                    throw GPUNotSupportedException("GPU is not supported on this device")
                }
            }
            DELEGATE_NNAPI -> {
                baseOptionsBuilder.useNnapi()
            }
        }

        val options = BertQuestionAnswererOptions.builder()
            .setBaseOptions(baseOptionsBuilder.build())
            .build()

        try {
            bertQuestionAnswerer =
                BertQuestionAnswerer.createFromFileAndOptions(context, BERT_QA_MODEL, options)
        } catch (e: IllegalStateException) {
            Log.e(TAG, "TFLite failed to load model with error: " + e.message)
            throw ModelInitializationException("Failed to initialize model")
        }
    }

    fun answer(contextOfQuestion: String, question: String): String? {
        if (bertQuestionAnswerer == null) {
            setupBertQuestionAnswerer()
        }

        val answers = bertQuestionAnswerer?.answer(contextOfQuestion, question)

        return answers?.get(0)?.text
    }

    companion object {
        private const val BERT_QA_MODEL = "mobilebert.tflite"
        private const val TAG = "BertQaHelper"
        const val DELEGATE_CPU = 0
        const val DELEGATE_GPU = 1
        const val DELEGATE_NNAPI = 2
    }
}
