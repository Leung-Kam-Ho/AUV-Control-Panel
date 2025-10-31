//
//  DeviceStatus.swift
//  CLP_Inspection_Robot_Panel
//
//  Created by Kam Ho Leung on 26/5/2025.
//

import Foundation
internal import Combine

//@Observable
class RobotStatus: Codable, ObservableObject, Equatable {
//    let objectWillChange = ObservableObjectPublisher()
    var connected: Bool = false
    var yaw: Double = 0
    var heading: Double = 0
    var depth: Double = 0
    
    static func == (lhs: RobotStatus, rhs: RobotStatus) -> Bool {
        return lhs.connected == rhs.connected
        && lhs.yaw == rhs.yaw
        && lhs.heading == rhs.heading
        && lhs.depth == rhs.depth
    }
}
