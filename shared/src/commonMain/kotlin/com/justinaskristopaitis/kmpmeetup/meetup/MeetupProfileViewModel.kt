package com.justinaskristopaitis.kmpmeetup.meetup

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlin.random.Random

class MeetupProfileViewModel(
    private val registerToMeetupUseCase: RegisterToMeetupUseCase? = null,
) {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private var loadJob: Job? = null
    private val _uiState = MutableStateFlow<MeetupProfileUiState>(MeetupProfileUiState.Loading)
    val uiState: StateFlow<MeetupProfileUiState> = _uiState.asStateFlow()

    private val _registeredAttendee = MutableStateFlow<RegisteredAttendee?>(null)
    val registeredAttendee: StateFlow<RegisteredAttendee?> = _registeredAttendee.asStateFlow()

    fun refresh() {
        loadJob?.cancel()
        loadJob = scope.launch {
            _uiState.value = MeetupProfileUiState.Loading
            val simulatedDelayMs = Random.nextLong(2_000, 5_001)
            delay(simulatedDelayMs)
            val content = MeetupProfileContent()
            _uiState.value = MeetupProfileUiState.Success(content)
        }
    }

    fun clear() {
        loadJob?.cancel()
        loadJob = null
    }

    suspend fun submitRegistration(rawName: String, rawEmail: String) {
        val name = rawName.trim()
        val email = rawEmail.trim()
        if (name.isEmpty() || email.isEmpty()) return

        val useCase = registerToMeetupUseCase
            ?: throw IllegalStateException("No use case")

        useCase(name, email).getOrElse { throw it }
        _registeredAttendee.value = RegisteredAttendee(displayName = name, email = email)
    }
}
