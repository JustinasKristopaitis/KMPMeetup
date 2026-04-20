package com.justinaskristopaitis.kmpmeetup

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

/**
 * Shared logic for tab 3: drives a [DemoPriority] without relying on Skie Flow interop.
 * Swift should use [DemoPriority.fromRaw] for any raw integer (including future values).
 */
class EnumTabViewModel {
    private val _priority = MutableStateFlow(DemoPriority.MEDIUM)
    val priority: StateFlow<DemoPriority> = _priority.asStateFlow()

    fun cycleKnownPriorities() {
        _priority.update { current ->
            when (current) {
                DemoPriority.LOW -> DemoPriority.MEDIUM
                DemoPriority.MEDIUM -> DemoPriority.HIGH
                DemoPriority.HIGH, DemoPriority.UNKNOWN -> DemoPriority.LOW
            }
        }
    }

    fun simulateUnknownRawFromApi() {
        _priority.value = DemoPriority.fromRaw(999)
    }
}
