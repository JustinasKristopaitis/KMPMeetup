package com.justinaskristopaitis.kmpmeetup.meetup

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
expect fun MeetupInAppWebEngine(url: String, modifier: Modifier)
