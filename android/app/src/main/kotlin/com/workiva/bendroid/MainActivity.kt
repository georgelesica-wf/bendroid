package com.workiva.bendroid

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private var sentPrUrl: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        if (Intent.ACTION_SEND == intent.action) {
            handleSendPrUrl()
        }

        MethodChannel(flutterView, "app.channel.shared.data").setMethodCallHandler()
        { call, result ->
            val isShare = call?.method?.contentEquals("getSharedPrUrl") == true
            val haveUrl = sentPrUrl != null
            if (isShare && haveUrl) {
                result.success(sentPrUrl)
                sentPrUrl = null
            }
        }
    }

    private fun handleSendPrUrl() {
        sentPrUrl = intent.getStringExtra(Intent.EXTRA_TEXT)
    }
}
