# iOS demo app (Xcode)

Native **Swift/SwiftUI** host that links the Kotlin **`Shared`** framework from `:shared`.

## Build the framework

From the **repository root**:

```bash
cd /path/to/KMPMeetup
./gradlew :shared:linkDebugFrameworkIosArm64 :shared:linkDebugFrameworkIosSimulatorArm64
```

Use the output that matches your run destination:

- **Simulator:** `shared/build/bin/iosSimulatorArm64/debugFramework/Shared.framework`
- **Device:** `shared/build/bin/iosArm64/debugFramework/Shared.framework`

The Xcode target sets **Framework Search Paths** to both folders and links with `-framework Shared`. For a single binary across slices, prefer an **XCFramework**
**Compose Multiplatform on iOS** expects **`CADisableMinimumFrameDurationOnPhone`** in the app’s merged `Info.plist` (ProMotion / frame pacing). This repo adds it via **`SupportingFiles/ComposeRequiredKeys.plist`**, merged by Xcode with the generated plist (`INFOPLIST_FILE`). Keep that file outside the synchronized `iOSApp/` sources folder so Xcode does not treat it as a duplicate `Info.plist` output.

## Sample tabs

The app shows a **three-tab** `TabView`:

1. **Shared** — `DemoComposeViewControllers.shared.sharedScreen()` (Compose Multiplatform inside UIKit).
2. **Native (Skie)** — **`NativeScreenDataModel`**: **`for await`** on **`state`**, **`onEnum`** on UI state, and **`try await fetchAsyncPreview()`** (Gradle turns **SuspendInterop** off by default; **`@SuspendInterop.Enabled`** opts in that `suspend` only).
3. **Native (plain)** — Same KMM model; **`IosFlowObservers`** for **`state`** + **`runFetchAsyncPreview`** (success/failure closures). **`toPlainUiModel() throws`** maps sealed state to **`NativeCounterPlainUiState`**.

Android: **`NativeScreenViewModel`** + **`NativeTabTwoAndroid`** include **“Run shared suspend (Kotlin)”** using coroutines (both tabs share the same Android behavior; tab copy still describes the iOS Skie vs callback story).

The **`Features/PriorityPicker/`** sample (enum / `DemoPriority.fromRaw`) remains in the repo for reference but is not wired into the tab bar.

Swift: `import Shared`, then use the types above. Kotlin `Int` arguments appear as **`KotlinInt`** (extends `NSNumber`); the app uses **`Core/KotlinInterop/KotlinInt+Swift.swift`** for small conversions.

## iOS module layout (MVVM + feature folders)

| Path | Role |
|------|------|
| `Features/Root/RootTabView.swift` | Tab shell only |
| `Features/SharedCompose/` | Shared UI tab: `*Models`, `*TabViewModel`, `*TabView` |
| `Features/NativeCounter/Shared/` | Strings, **`NativeCounterCoordinating`**, plain UI state + **`toPlainUiModel()`** |
| `Features/NativeCounter/SkieScreen/` | **`NativeCounterSkieScreenView`** (Skie `onEnum` UI) |
| `Features/NativeCounter/SkieTab/` | **`NativeCounterSkieTabView`**, **`NativeCounterSkieTabViewModel`**, **`NativeCounterSkieTabDataModel`** (alias → KMM) |
| `Features/NativeCounter/PlainScreen/` | **`NativeCounterPlainScreenView`** (mapped **`NativeCounterPlainUiState`**) |
| `Features/NativeCounter/PlainTab/` | **`NativeCounterPlainTabView`**, **`NativeCounterPlainTabViewModel`**, **`NativeCounterPlainTabDataModel`** (alias → KMM) |
| `Features/PriorityPicker/` | *(optional reference)* Enum / raw mapping: models, **mapper**, view model, view |
| `Core/KotlinInterop/` | Thin Kotlin ↔ Swift helpers |

Tab folders hold **tab + tab VM + tab data model**; **screen** folders hold the feature **screen** UI. The root tab view does not host business logic.
