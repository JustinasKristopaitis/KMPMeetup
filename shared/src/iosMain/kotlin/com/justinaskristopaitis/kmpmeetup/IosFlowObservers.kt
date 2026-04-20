package com.justinaskristopaitis.kmpmeetup

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class FlowObserverHandle internal constructor(private val scope: CoroutineScope) {
    fun cancel() {
        scope.cancel()
    }
}

@Suppress("unused")
object IosFlowObservers {
    fun subscribeNativeScreenDataModel(
        dataModel: NativeScreenDataModel,
        onEach: (NativeScreenUiState) -> Unit,
    ): FlowObserverHandle {
        val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
        scope.launch {
            dataModel.state.collect { onEach(it) }
        }
        return FlowObserverHandle(scope)
    }

    fun runFetchAsyncPreview(
        dataModel: NativeScreenDataModel,
        onSuccess: (String) -> Unit,
        onFailure: (String) -> Unit,
    ): FlowObserverHandle {
        val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
        scope.launch {
            try {
                val result = dataModel.fetchAsyncPreview()
                onSuccess(result)
            } catch (t: Throwable) {
                onFailure(t.message ?: "Unknown error")
            }
        }
        return FlowObserverHandle(scope)
    }

    fun subscribeEnumTabViewModel(
        vm: EnumTabViewModel,
        onEach: (rawValue: Int) -> Unit,
    ): FlowObserverHandle {
        val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
        scope.launch {
            vm.priority.collect { priority ->
                onEach(priority.rawValue)
            }
        }
        return FlowObserverHandle(scope)
    }
}
