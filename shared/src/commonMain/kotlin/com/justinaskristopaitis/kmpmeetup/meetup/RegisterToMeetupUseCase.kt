package com.justinaskristopaitis.kmpmeetup.meetup

import kotlinx.coroutines.delay

class RegisterToMeetupUseCase {
    private companion object {
        const val REGISTRATION_DELAY_MS = 450L
    }

    suspend operator fun invoke(name: String, email: String): Result<Unit> {
        delay(REGISTRATION_DELAY_MS)
        return Result.success(Unit)
    }
}
