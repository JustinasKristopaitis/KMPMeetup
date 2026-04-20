package com.justinaskristopaitis.kmpmeetup.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Info
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.justinaskristopaitis.kmpmeetup.NativeScreenUiState
import com.justinaskristopaitis.kmpmeetup.NativeScreenViewModel
import com.justinaskristopaitis.kmpmeetup.meetup.MeetupInAppWebBottomSheet
import kotlinx.coroutines.launch

/**
 * Native Android Compose shell around the Android-only [NativeScreenViewModel], which forwards
 * to shared [NativeScreenDataModel]. The [interopSubtitle] describes the paired iOS tab (Skie vs callbacks).
 */
private object SkieDocCopy {
    const val url = "https://skie.touchlab.co"
    const val sheetTitle = "Skie"
    const val sheetSubtitle = "Official Touchlab Skie documentation — opens in-app like LinkedIn on the meetup tab."
    const val close = "Close"
    const val infoFab = "Skie documentation"
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NativeTabTwoAndroid(
    viewModel: NativeScreenViewModel,
    interopSubtitle: String,
    modifier: Modifier = Modifier,
    showSkieDocumentationFab: Boolean = false,
) {
    val uiState by viewModel.uiState.collectAsState()
    val scope = rememberCoroutineScope()
    var asyncLine by remember { mutableStateOf<String?>(null) }
    var skieDocOpen by remember { mutableStateOf(false) }
    val skieDocSheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)

    Box(modifier = modifier.fillMaxSize()) {
        Surface(modifier = Modifier.fillMaxSize()) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(24.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically),
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
            Text(
                text = "Native Android UI",
                style = MaterialTheme.typography.headlineSmall,
            )
            Text(
                text = interopSubtitle,
                style = MaterialTheme.typography.bodyMedium,
                textAlign = TextAlign.Center,
            )
            when (val s = uiState) {
                NativeScreenUiState.Loading -> {
                    Text(
                        text = "Updating counter…",
                        style = MaterialTheme.typography.titleMedium,
                    )
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth(0.85f))
                    Text(
                        text = "Same loading / success model as the shared meetup tab.",
                        style = MaterialTheme.typography.bodySmall,
                        textAlign = TextAlign.Center,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                is NativeScreenUiState.Success -> {
                    Text(
                        text = "Count: ${s.count}",
                        style = MaterialTheme.typography.displaySmall,
                    )
                    Text(
                        text = s.message,
                        style = MaterialTheme.typography.bodyLarge,
                        textAlign = TextAlign.Center,
                    )
                    Button(onClick = viewModel::increment) {
                        Text("Increment (shared logic)")
                    }
                    OutlinedButton(
                        onClick = {
                            scope.launch {
                                asyncLine = "Running shared suspend…"
                                asyncLine = viewModel.fetchAsyncPreview()
                            }
                        },
                    ) {
                        Text("Run shared suspend (Kotlin)")
                    }
                    asyncLine?.let { line ->
                        Text(
                            text = line,
                            style = MaterialTheme.typography.bodySmall,
                            textAlign = TextAlign.Center,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }
            }
        }

        if (showSkieDocumentationFab) {
            FloatingActionButton(
                onClick = { skieDocOpen = true },
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .navigationBarsPadding()
                    .padding(20.dp),
                containerColor = MaterialTheme.colorScheme.primaryContainer,
                contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
            ) {
                Icon(
                    imageVector = Icons.Default.Info,
                    contentDescription = SkieDocCopy.infoFab,
                )
            }
        }
    }

    if (showSkieDocumentationFab) {
        MeetupInAppWebBottomSheet(
            visible = skieDocOpen,
            onDismissRequest = { skieDocOpen = false },
            sheetState = skieDocSheetState,
            title = SkieDocCopy.sheetTitle,
            subtitle = SkieDocCopy.sheetSubtitle,
            url = SkieDocCopy.url,
            closeLabel = SkieDocCopy.close,
            closeContentDescription = SkieDocCopy.close,
        )
    }
}
