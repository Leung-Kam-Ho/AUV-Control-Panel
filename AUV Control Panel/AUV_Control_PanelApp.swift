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
            let placeholder =
            Color.clear
                .padding()
                .background(RoundedRectangle(cornerRadius: 49).fill(.ultraThinMaterial).stroke(.white))
                .padding()
            HStack{
                ContentView()
                placeholder
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
