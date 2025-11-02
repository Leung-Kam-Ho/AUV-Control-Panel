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
    @StateObject var robotStatus = RobotStatusObject()
    var body: some Scene {
        
        WindowGroup {
            HStack{
                ContentView()
            }
            .scrollContentBackground(.hidden)
            .font(.title2)
            .contentTransition(.numericText(countsDown: true))
            .background(Image("Watermark"))
            .bold()
            .preferredColorScheme(.dark)
            .monospacedDigit()
            .environmentObject(settings)
            .environmentObject(robotStatus)
            .onReceive(robotStatus.timer, perform: { _ in
                Logger().info("robot Fetching Status")
                robotStatus.fetchStatus(ip: settings.ip, port: settings.port)
                print(robotStatus.status.connected)
            })
//            .tabViewStyle(./*sidebarAdaptable*/)
        }
        .defaultSize(Constants.windowMinSize)
        
    }
}
