//
//  StorageHandler.swift
//  CLP_Inspection_Robot_Panel
//
//  Created by Kam Ho Leung on 24/5/2025.
//

import Foundation
import os
import SwiftUI
internal import Combine


class SettingsHandler : ObservableObject{
    let objectWillChange = ObservableObjectPublisher()
    @AppStorage("rosIP") var ip : String = "localhost"
    @AppStorage("rosPort") var port : Int = 5000
    @AppStorage("cameraIP") var cam_ip : String = "localhost"
    @AppStorage("cameraPort") var cam_port : Int = 4000
    @AppStorage("yoloIP") var yolo_ip : String = "localhost"
    @AppStorage("yoloPort") var yolo_port : Int = 4001
    @AppStorage("updateRate") var updateRate : Double = 1.0
    @AppStorage("splitScreen") var splitScreen : Bool = false

    init() {

    }
}
