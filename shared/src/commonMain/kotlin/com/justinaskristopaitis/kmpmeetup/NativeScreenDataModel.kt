package com.justinaskristopaitis.kmpmeetup

import co.touchlab.skie.configuration.annotations.FlowInterop
import co.touchlab.skie.configuration.annotations.SuspendInterop
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

/**
 * KMM **data model** — owns the counter state machine. Platform view models (Android `NativeScreenViewModel`,
 * Swift tab VMs) wrap this and map to UI.
 *
 * **Skie (iOS):** [state] is [FlowInterop.Enabled] so Swift may collect it as `AsyncSequence`.
 * **[fetchAsyncPreview]** is [SuspendInterop.Enabled] so Swift may call it as `async`/`await`.
 * **Plain iOS:** `IosFlowObservers.runFetchAsyncPreview` runs the same suspend on the Kotlin side and delivers the result via callbacks (no Skie `async` in Swift).
 *
 * Android uses normal `collect` / `collectAsState` on the same flow, and `suspend` from any coroutine.
 */
class NativeScreenDataModel {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private var bumpJob: Job? = null
    private var committedCount = 0

    private val _state = MutableStateFlow<NativeScreenUiState>(
        NativeScreenUiState.Success(0, INITIAL_MESSAGE),
    )

    @FlowInterop.Enabled
    val state: StateFlow<NativeScreenUiState> = _state.asStateFlow()

    fun increment() {
        bumpJob?.cancel()
        bumpJob = scope.launch {
            _state.value = NativeScreenUiState.Loading
            delay(Random.nextLong(400L, 1_200L))
            committedCount += 1

            _state.value = NativeScreenUiState.Success(
                committedCount,
                "Last bump at count $committedCount",
            )
        }
    }

    /**
     * Demo: shared `suspend` for “async/await” talks. Skie exposes this as Swift `async throws`;
     * without Skie interop, call from Kotlin (e.g. [IosFlowObservers.runFetchAsyncPreview]).
     */
    @SuspendInterop.Enabled
    suspend fun fetchAsyncPreview(): String {
        delay(650L)
        return "KMM suspend completed (shared logic, ~650ms delay)"
    }

    private companion object {
        const val INITIAL_MESSAGE = "State comes from shared KMP code"
    }
}
