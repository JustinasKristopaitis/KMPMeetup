package com.justinaskristopaitis.kmpmeetup

import android.app.Application
import com.justinaskristopaitis.kmpmeetup.di.appModule
import com.justinaskristopaitis.kmpmeetup.di.sharedAppModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class KmpMeetupApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@KmpMeetupApplication)
            modules(appModule, sharedAppModule())
        }
    }
}
