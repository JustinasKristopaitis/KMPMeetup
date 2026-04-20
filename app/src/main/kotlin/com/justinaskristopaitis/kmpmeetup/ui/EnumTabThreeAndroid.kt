package com.justinaskristopaitis.kmpmeetup.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.justinaskristopaitis.kmpmeetup.DemoPriority
import com.justinaskristopaitis.kmpmeetup.EnumTabViewModel

/**
 * Tab 3 — Android: native Compose; shared [EnumTabViewModel] + [DemoPriority] with safe default.
 */
@Composable
fun EnumTabThreeAndroid(
    viewModel: EnumTabViewModel,
    modifier: Modifier = Modifier,
) {
    val priority by viewModel.priority.collectAsState()

    Surface(modifier = modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Text(
                text = "Native Android UI (enum)",
                style = MaterialTheme.typography.headlineSmall,
            )
            Text(
                text = "DemoPriority falls back to UNKNOWN for unknown raw values (no Skie).",
                style = MaterialTheme.typography.bodyMedium,
                textAlign = TextAlign.Center,
            )
            Text(
                text = "Current: ${priority.label} (raw ${priority.rawValue})",
                style = MaterialTheme.typography.titleLarge,
                textAlign = TextAlign.Center,
            )
            Button(onClick = viewModel::cycleKnownPriorities) {
                Text("Cycle LOW → MEDIUM → HIGH")
            }
            Button(onClick = viewModel::simulateUnknownRawFromApi) {
                Text("Simulate bad API raw (→ UNKNOWN)")
            }
            Text(
                text = "fromRaw(999) → ${DemoPriority.fromRaw(999).label}",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.secondary,
            )
        }
    }
}
