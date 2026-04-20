package com.justinaskristopaitis.kmpmeetup.di

import com.justinaskristopaitis.kmpmeetup.meetup.RegisterToMeetupUseCase
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module

val appModule = module {
    singleOf(::RegisterToMeetupUseCase)
}
