package com.justinaskristopaitis.kmpmeetup.di

import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.mp.KoinPlatformTools

fun initSharedKoin(vararg extraModules: Module) {
    startKoin {
        modules(sharedAppModule(), *extraModules)
    }
}
fun ensureSharedKoinStarted(vararg extraModules: Module) {
    if (KoinPlatformTools.defaultContext().getOrNull() != null) return
    initSharedKoin(*extraModules)
}
