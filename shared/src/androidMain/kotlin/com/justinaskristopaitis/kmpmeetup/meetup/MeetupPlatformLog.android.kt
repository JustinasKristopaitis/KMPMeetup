package com.justinaskristopaitis.kmpmeetup.meetup

import android.util.Log

internal actual fun meetupPlatformLog(tag: String, message: String, error: Throwable?) {
    if (error != null) {
        Log.e(tag, message, error)
    } else {
        Log.e(tag, message)
    }
}
