package com.justinaskristopaitis.kmpmeetup.ui

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.justinaskristopaitis.kmpmeetup.NativeScreenViewModel
import com.justinaskristopaitis.kmpmeetup.meetup.MeetupProfileScreen
import com.justinaskristopaitis.kmpmeetup.meetup.MeetupProfileViewModel
import org.koin.compose.koinInject

private enum class MeetupTab(val shortLabel: String) {
    SHARED("Shared"),
    NATIVE_SKIE("Native+Skie"),
    NATIVE_PLAIN("Native plain"),
}

@Composable
fun MeetupTabScaffold(modifier: Modifier = Modifier) {
    var selectedIndex by rememberSaveable { mutableIntStateOf(0) }
    val tabs = MeetupTab.entries

    val meetupProfileVm: MeetupProfileViewModel = koinInject()
    val nativeSkieVm = remember { NativeScreenViewModel() }
    val nativePlainVm = remember { NativeScreenViewModel() }

    Scaffold(
        modifier = modifier.fillMaxSize(),
        bottomBar = {
            NavigationBar {
                tabs.forEachIndexed { index, tab ->
                    NavigationBarItem(
                        selected = selectedIndex == index,
                        onClick = { selectedIndex = index },
                        icon = {
                            Text(
                                text = when (tab) {
                                    MeetupTab.SHARED -> "①"
                                    MeetupTab.NATIVE_SKIE -> "②"
                                    MeetupTab.NATIVE_PLAIN -> "③"
                                },
                                style = MaterialTheme.typography.titleMedium,
                            )
                        },
                        label = { Text(tab.shortLabel) },
                    )
                }
            }
        },
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding),
            contentAlignment = Alignment.TopCenter,
        ) {
            when (tabs[selectedIndex]) {
                MeetupTab.SHARED -> MeetupProfileScreen(viewModel = meetupProfileVm)
                MeetupTab.NATIVE_SKIE -> NativeTabTwoAndroid(
                    viewModel = nativeSkieVm,
                    interopSubtitle = "On iOS: Skie Flow + Suspend — `for await` on state, `try await fetchAsyncPreview()`.",
                    modifier = Modifier.padding(top = 16.dp),
                    showSkieDocumentationFab = true,
                )
                MeetupTab.NATIVE_PLAIN -> NativeTabTwoAndroid(
                    viewModel = nativePlainVm,
                    interopSubtitle = "On iOS: callbacks — `IosFlowObservers` for state + `runFetchAsyncPreview` (no Skie async).",
                    modifier = Modifier.padding(top = 16.dp),
                )
            }
        }
    }
}
