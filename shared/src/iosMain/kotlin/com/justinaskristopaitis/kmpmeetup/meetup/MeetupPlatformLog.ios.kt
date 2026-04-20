package com.justinaskristopaitis.kmpmeetup.meetup

internal actual fun meetupPlatformLog(tag: String, message: String, error: Throwable?) {
    if (error != null) {
        println("[$tag] $message: ${error.message}")
        error.printStackTrace()
    } else {
        println("[$tag] $message")
    }
}
