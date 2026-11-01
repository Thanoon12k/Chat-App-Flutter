package com.thanoon12k.chatapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("chat_messages", "رسائل الدردشة", NotificationManager.IMPORTANCE_HIGH)
            channel.description = "إشعارات المحادثات والغرف"
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }
}
