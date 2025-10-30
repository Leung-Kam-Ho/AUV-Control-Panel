//
//  AUV_Control_PanelApp.swift
//  AUV Control Panel
//
//  Created by KamHo on 30/10/25.
//

import SwiftUI
import os


@main
struct AUV_Control_PanelApp: App {
    @StateObject var settings = SettingsHandler()
    var body: some Scene {
        
        WindowGroup {
            
            HStack{
                ContentView()
                
            }
            .font(.title2)
            .background(Image("Watermark"))
            .environmentObject(settings)
            .scrollContentBackground(.hidden)
            .bold()
            .preferredColorScheme(.dark)
            .monospacedDigit()
            .tabViewStyle(.sidebarAdaptable)
        }
        
    }
}
