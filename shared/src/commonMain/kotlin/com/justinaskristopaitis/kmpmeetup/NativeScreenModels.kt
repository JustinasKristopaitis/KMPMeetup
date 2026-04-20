package com.justinaskristopaitis.kmpmeetup

import co.touchlab.skie.configuration.annotations.SealedInterop

@SealedInterop.Enabled
sealed interface NativeScreenUiState {
    data object Loading : NativeScreenUiState

    data class Success(
        val count: Int,
        val message: String,
    ) : NativeScreenUiState
}
