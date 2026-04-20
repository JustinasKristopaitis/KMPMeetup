package com.justinaskristopaitis.kmpmeetup

import kotlinx.coroutines.flow.StateFlow


class NativeScreenViewModel(
    private val dataModel: NativeScreenDataModel = NativeScreenDataModel(),
) {
    val uiState: StateFlow<NativeScreenUiState> get() = dataModel.state

    fun increment() {
        dataModel.increment()
    }

    suspend fun fetchAsyncPreview(): String = dataModel.fetchAsyncPreview()
}
