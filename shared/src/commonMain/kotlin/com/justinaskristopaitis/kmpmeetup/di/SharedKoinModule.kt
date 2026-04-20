package com.justinaskristopaitis.kmpmeetup.di

import com.justinaskristopaitis.kmpmeetup.meetup.MeetupProfileViewModel
import com.justinaskristopaitis.kmpmeetup.meetup.RegisterToMeetupUseCase
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module

fun sharedAppModule() = module {
    // single { RegisterToMeetupUseCase() }
    singleOf(::RegisterToMeetupUseCase)

    single {
        MeetupProfileViewModel(
            registerToMeetupUseCase = getOrNull<RegisterToMeetupUseCase>(),
        )
    }
}
