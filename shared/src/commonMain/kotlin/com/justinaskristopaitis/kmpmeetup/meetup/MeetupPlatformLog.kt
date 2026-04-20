package com.justinaskristopaitis.kmpmeetup.meetup

/** Log connectivity / HTTP failures (Logcat on Android, stdout on iOS). */
internal expect fun meetupPlatformLog(tag: String, message: String, error: Throwable? = null)
