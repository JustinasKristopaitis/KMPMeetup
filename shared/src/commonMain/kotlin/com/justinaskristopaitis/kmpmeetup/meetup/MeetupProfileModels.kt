package com.justinaskristopaitis.kmpmeetup.meetup

data class RegisteredAttendee(
    val displayName: String,
    val email: String,
)

data class MeetupProfileContent(
    val welcomeTitle: String = "Welcome to Kotlin Meetup 🚀",
    val eventSubtitle: String = "Knowledge sharing event",
    val venueLine: String = "At Business Stadium North, Vilnius",
    val hostLine: String = "Justinas Kristopaitis",
    val linkedInUrl: String = "https://www.linkedin.com/in/justinaskristopaitis/",
)

sealed interface MeetupProfileUiState {
    data object Loading : MeetupProfileUiState

    data class Success(
        val content: MeetupProfileContent = MeetupProfileContent(),
    ) : MeetupProfileUiState

    data class Error(
        val message: String,
    ) : MeetupProfileUiState
}
