# KMP Meetup

**Kotlin Multiplatform** demo project for talks and workshops: one **`Shared`** KMP module, an **Android** app, and a native **iOS** app in **`iOSApp/`** that links the same framework.

**Connect:** [Justinas Kristopaitis on LinkedIn](https://www.linkedin.com/in/justinaskristopaitis/)

---

## What it is

- **`:shared`** — common Kotlin (and Compose Multiplatform UI where used), compiled for Android and iOS.
- **`:app`** — Android application.
- **`iOSApp/`** — Swift/SwiftUI host that embeds **`Shared.framework`** and demonstrates two styles of Kotlin ↔ Swift interop side by side.

---

## What it does

**Android** runs the shared code and mirrors the “native tab” stories (including calling shared **suspend** APIs from Kotlin).

**iOS** uses a three-tab shell:

1. **Shared** — Compose Multiplatform content from the shared module, hosted in the iOS app.
2. **Native (Skie)** — SwiftUI screens wired through **Skie** (e.g. sealed state / enums, Swift **async/await** for opted-in **suspend** APIs).
3. **Native (plain)** — the same KMM types, but **without** Skie’s async bridge: flows via **`IosFlowObservers`**, suspend via **callbacks**.

The shared **meetup profile** UI also demonstrates an in-app **LinkedIn** sheet; the profile URL matches the link above.

For file-level layout and Gradle commands to build the iOS framework, see **[`iOSApp/README.md`](iOSApp/README.md)**.

---

## Quick start

**Android**

```bash
./gradlew :app:assembleDebug
```

**iOS** — from the repo root, build the framework slices you need, then open **`iOSApp/iOSApp.xcodeproj`** and run.

```bash
./gradlew :shared:linkDebugFrameworkIosArm64 :shared:linkDebugFrameworkIosSimulatorArm64
```

Simulator vs device output paths are documented in [`iOSApp/README.md`](iOSApp/README.md).

---

## License

[MIT](LICENSE) © 2026 Justinas Kristopaitis
