import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            SharedComposeTabView()
                .tabItem {
                    Label(
                        SharedComposePresentationModel.default.tabTitle,
                        systemImage: SharedComposePresentationModel.default.tabSystemImageName
                    )
                }

            NativeCounterSkieTabView()
                .tabItem {
                    Label(
                        NativeCounterStrings.Tab.skieTitle,
                        systemImage: NativeCounterStrings.Tab.skieSystemImageName
                    )
                }

            NativeCounterPlainTabView()
                .tabItem {
                    Label(
                        NativeCounterStrings.Tab.plainTitle,
                        systemImage: NativeCounterStrings.Tab.plainSystemImageName
                    )
                }
        }
    }
}

#Preview {
    RootTabView()
}
