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
    @State var refreshView = false
    @State var popoverIsPresented: Bool = false
    @State var viewModel = ViewModel()
    var cleanUI = false
    var body: some View {
        let web = WebView(ip: "http://\(settings.cam_ip)")
//            .scaledToFit()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 33))
//            .disabled(true)
            .id(refreshView)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        ZStack{
            Color.clear
            VStack{
                web
                    .padding()
//                    .aspectRatio(1, contentMode: .fill)
//                Spacer()
            }
            
        }
        .overlay(alignment: .bottom, content: {
            Label("Camera View", systemImage: "person.and.background.dotted")
                .padding()
                .background(Capsule().fill(Material.ultraThick))
        })
        .overlay(alignment: .bottomTrailing, content: {
            HStack{
                Menu(content: {
                    Button("Robot IP/Hostname"){
                        viewModel.showAlert.toggle()
                    }.tag(viewModel.custom_ip)
                    Text("Robot IP : \(settings.ip)")
                    Divider()
                    Button("Camera IP/Hostname"){
                        viewModel.showAlert_camera.toggle()
                    }.tag(viewModel.custom_cam_ip)
                    Text("Camera IP : \(settings.cam_ip)")
                    Divider()
                    Button("Change Fetch Rate"){
//                            viewModel.showAlert_fetch.toggle()
                    }
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .padding()
                        .background(Circle().fill(Material.ultraThick))
                }).buttonStyle(.plain)

                Button(action: {
                    refreshView.toggle()
                }){
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                        .padding()
                        .background(Circle().fill(Material.ultraThick))
                }
            }
        })
        .onAppear{
            refreshView.toggle()
        }
        .alert("Enter custom IP", isPresented:$viewModel.showAlert) {
            TextField("Enter custom IP", text: $viewModel.custom_ip)
                .font(.caption)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: {
                settings.ip = viewModel.custom_ip
            })
        } message: {
            Text("Xcode will print whatever you type.")
        }
        .alert("Enter custom camera IP", isPresented:$viewModel.showAlert_camera) {
            TextField("Enter custom camera IP", text: $viewModel.custom_cam_ip)
                .font(.caption)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: {
                settings.cam_ip = viewModel.custom_cam_ip
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
        var custom_ip = ""
        var custom_cam_ip = ""
        var show = false
    }
}
