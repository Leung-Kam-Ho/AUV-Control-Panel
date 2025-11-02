//
//  WebView.swift
//  CLP_Inspection_Robot_Panel
//
//  Created by Kam Ho Leung on 20/9/2024.
//

import SwiftUI
import WebKit
import os
import SwiftUI



struct Camera_WebView : View {
    @EnvironmentObject var settings : SettingsHandler
    @EnvironmentObject var robotStatus: RobotStatusObject
    @State var refreshView = false
    @State var popoverIsPresented: Bool = false
    @State var viewModel = ViewModel()
    var cleanUI = false
    var body: some View {
        let web = WebView(ip: viewModel.show_normal ? "http://\(settings.cam_ip)" : "http://\(settings.yolo_ip)")
//            .scaledToFit()
//            .clipShape(RoundedRectangle(cornerRadius: 33))
            .id(refreshView)
        ZStack{
            Color.clear
            VStack{
                web
            }
            
        }
        .overlay(alignment: .bottom, content: {
            Button(action:{
               withAnimation {
                    viewModel.show_normal.toggle()
                    refreshView.toggle()
                }
            }){
                Label(viewModel.show_normal ? "Camera View" : "YOLO View", systemImage: "person.and.background.dotted")
                    .padding()
                    .background(Capsule().fill(Material.ultraThick))
                    .padding()
            }
        })
        .overlay(alignment: .bottomTrailing, content: {
            HStack{
                Menu(content: {
                    Button("Robot IP/Hostname"){
                        viewModel.showAlert.toggle()
                    }
                    Text("Robot IP : \(settings.ip)")
                    Divider()
                    Button("Camera IP/Hostname"){
                        viewModel.showAlert_camera.toggle()
                    }
                    Text("Camera IP : \(settings.cam_ip)")
                    Divider()
                    Button("Yolo IP/Hostname"){
                        viewModel.showAlert_yolo.toggle()
                    }
                    Text("Yolo IP : \(settings.yolo_ip)")
                    Divider()
                    Button("Change Fetch Rate"){
                            viewModel.showAlert_fetch.toggle()
                    }
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .padding()
                        .background(Circle().fill(Material.ultraThick))
                }).buttonStyle(.plain)
                
                Button(action: {
                    settings.splitScreen.toggle()
                }){
                    Image(systemName: "square.split.2x1")
                        .padding()
                        .background(Circle().fill(Material.ultraThick))
                }

                Button(action: {
                    refreshView.toggle()
                }){
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                        .padding()
                        .background(Circle().fill(Material.ultraThick))
                }
            }.padding()
        })
        .onAppear{
            refreshView.toggle()
        }
            .alert("Slect Fetch Rate", isPresented:$viewModel.showAlert_fetch){
                Button("\((1/Constants.SLOW_RATE)) FPS"){
                    robotStatus.updateTimerRate(to: Constants.SLOW_RATE)
                    Logger().info("Changed FPS to \(Constants.SLOW_RATE)")
                }
                Button("\((1/Constants.MEDIUM_RATE)) FPS"){
//                    station.dataUpdateRate(Constants.MEDIUM_RATE)
                    robotStatus.updateTimerRate(to: Constants.MEDIUM_RATE)
                    Logger().info("Changed FPS to \(Constants.MEDIUM_RATE)")
                }
                Button("\((1/Constants.INTENSE_RATE)) FPS"){
//                    station.dataUpdateRate(Constants.INTENSE_RATE)
                    robotStatus.updateTimerRate(to: Constants.INTENSE_RATE)
                    Logger().info("Changed FPS to \(Constants.INTENSE_RATE)")
                }

            }
        .alert("Enter custom IP", isPresented:$viewModel.showAlert) {
            TextField("Enter custom IP", text: $settings.ip)
                .font(.caption)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: {
//                settings.ip = viewModel.custom_ip
            })
        } message: {
            Text("Xcode will print whatever you type.")
        }
        .alert("Enter custom camera IP", isPresented:$viewModel.showAlert_camera) {
            TextField("Enter custom camera IP", text: $settings.cam_ip)
                .font(.caption)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: {
//                settings.cam_ip = viewModel.custom_cam_ip
            })
        } message: {
            Text("Xcode will print whatever you type.")
        }
        .alert("Enter yolo IP", isPresented:$viewModel.showAlert_yolo) {
            TextField("Enter yolo IP", text: $settings.yolo_ip)
                .font(.caption)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: {
//                settings.cam_ip = viewModel.custom_cam_ip
            })
        } message: {
            Text("Xcode will print whatever you type.")
        }
        
        

    }
}

struct WebView: UIViewRepresentable {
    let ip : String
    let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        webView.isOpaque = false
        webView.backgroundColor = UIColor(Color.clear)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadURL()
    }
    
    func loadURL(){
        webView.load(URLRequest(url: URL(string: ip)!))
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }
        
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("WebView started loading")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView finished loading")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView failed with error: \(error)")
            self.parent.loadURL()
        }
    }
    
}


extension Camera_WebView {
    @Observable
    class ViewModel{
        var pop = false
        var showAlert = false
        var showAlert_camera = false
        var showAlert_fetch = false
        var showAlert_yolo = false
        var show = false
        var show_normal = true
    }
}
