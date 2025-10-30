import SwiftUI
import os

struct ContentView: View {
    @EnvironmentObject var settings : SettingsHandler
    @State var viewModel = ViewModel()
    @AppStorage("MyAppTabViewCustomization")
    private var customization: TabViewCustomization
    var body: some View {
        
        GeometryReader{ screen in
            //Views
//            let bigEnough = UIScreen.main.traitCollection.userInterfaceIdiom == .pad
//            let height = screen.size.height
            let camera =
            Camera_WebView()
                .padding()
                .background(RoundedRectangle(cornerRadius: 49).fill(.ultraThinMaterial).stroke(.white))
                .padding()
            let controlView =
            ControlView()
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 49).fill(.ultraThinMaterial).stroke(.white))
//                .padding()
            
            //Main
            HStack{
                    camera
                    TabView(selection: self.$viewModel.selectedTab){
                        Tab("All", systemImage: "widget.small", value: Tabs.All){
                            controlView
                                
                        }
                        Tab("Auto",systemImage:"point.topright.filled.arrow.triangle.backward.to.point.bottomleft.scurvepath",value: Tabs.Control){
                            
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 49).fill(.ultraThinMaterial).stroke(.white))
                    .padding()
                    .tabViewStyle(.tabBarOnly)
                
            }
        }
    }

}

extension ContentView{
    enum Tabs : Hashable{
        case All
        case Auto
        case Control
        case LaunchPlatform
        case Camera
        case placeHolder
    }
    enum CameraMode : String , CaseIterable{
        case half = "inset.filled.lefthalf.righthalf.rectangle"
        case none = "inset.filled.topleft.topright.bottomleft.bottomright.rectangle"
    }
    @Observable
    class ViewModel{
        var selectedTab: Tabs = .All
//        var selectedTabRight: Tabs = .All
        var camera_tab_toggle = false
        var cameraMode : CameraMode = .none
    }
}
