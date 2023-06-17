package com.example.icici

import io.flutter.embedding.android.FlutterActivity
import android.content.IntentFilter
import android.os.Bundle
import com.shounakmulay.telephony.sms.IncomingSmsReceiver // Replace with your receiver class name

class MainActivity: FlutterActivity() {
    private val smsReceiver = IncomingSmsReceiver()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Register the SMS receiver
        val filter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        registerReceiver(smsReceiver, filter)
    }

    override fun onDestroy() {
        super.onDestroy()

        // Unregister the SMS receiver when the activity is destroyed
        unregisterReceiver(smsReceiver)
    }
}
