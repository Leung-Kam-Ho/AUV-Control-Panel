import SwiftUI
import os

struct ContentView: View {
    @EnvironmentObject var robotStatus: RobotStatusObject
    @EnvironmentObject var settings : SettingsHandler
    @State var viewModel = ViewModel()
    @AppStorage("MyAppTabViewCustomization")
    private var customization: TabViewCustomization

    var body: some View {
        
        GeometryReader{ screen in
            //Views
//            let bigEnough = UIScreen.main.traitCollection.userInterfaceIdiom == .pad
            let bigEnough = screen.size.width > Constants.contentMinSize.width && screen.size.height > Constants.contentMinSize.height
//            let height = screen.size.height
            let camera =
            Camera_WebView()
                .padding()
            let controlView = ControlView()
            
            //Main
            HStack{
                if bigEnough{
                    camera
                }
                TabView(selection: self.$viewModel.selectedTab){
                    Tab("Control", systemImage: "widget.small", value: Tabs.All){
                        controlView
                    }
                    if !bigEnough{
                        Tab("Camera", systemImage: "camera.fill", value: Tabs.Camera){
                            camera
                        }
                    }
                    Tab("Auto",systemImage:"point.topright.filled.arrow.triangle.backward.to.point.bottomleft.scurvepath",value: Tabs.Control){
                        
                    }
                }.clipShape(RoundedRectangle(cornerRadius: 33))

                .scrollContentBackground(.hidden)
                .toolbarBackground(.hidden, for: .tabBar)
                .padding()
                .background(RoundedRectangle(cornerRadius: 49).fill(.ultraThinMaterial).stroke(.white))
                .padding()
                
                
                
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
