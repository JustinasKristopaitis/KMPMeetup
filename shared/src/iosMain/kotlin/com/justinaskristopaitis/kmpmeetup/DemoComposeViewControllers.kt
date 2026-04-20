package com.justinaskristopaitis.kmpmeetup

import androidx.compose.ui.window.ComposeUIViewController
import com.justinaskristopaitis.kmpmeetup.di.ensureSharedKoinStarted
import com.justinaskristopaitis.kmpmeetup.meetup.MeetupProfileScreen
import com.justinaskristopaitis.kmpmeetup.meetup.MeetupProfileViewModel
import org.koin.mp.KoinPlatform
import platform.UIKit.UIViewController

@Suppress("unused")
object DemoComposeViewControllers {
    fun sharedScreen(): UIViewController {
        ensureSharedKoinStarted()
        val vm = KoinPlatform.getKoin().get<MeetupProfileViewModel>()
        return ComposeUIViewController(
            configure = {
                enforceStrictPlistSanityCheck = false
            },
        ) {
            MeetupProfileScreen(viewModel = vm)
        }
    }
}
