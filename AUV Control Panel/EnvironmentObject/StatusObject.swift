//swift
//  CLP_Inspection_Robot_Panel
//
//  Created by Kam Ho Leung on 26/5/2025.
//

import Foundation
import SwiftUI
import os
internal import Combine

// Base class for status objects to avoid code duplication
class BaseStatusObject<T>: ObservableObject where T: Decodable & Equatable {
//    let objectWillChange = ObservableObjectPublisher()
    @Published var status: T
    private let initialStatus: T
    private let networkManager = NetworkManager.shared
    private let statusRoute: String
    @Published var timer = Timer.publish(every: Constants.SLOW_RATE, on: .main, in: .common).autoconnect()
    
    init(initialStatus: T, statusRoute: String) {
        self.initialStatus = initialStatus
        self.status = initialStatus
        self.statusRoute = statusRoute
    }
    
    func fetchStatus(ip: String, port: Int) {
        NetworkManager.getRequest(ip: ip, port: port, route: statusRoute) { (result: Result<T, Error>) in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    withAnimation(.easeInOut){
                        if self.status != status {
                            print("Status updated: \(status)")
                            
                            self.status = status
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // Handle error on the main thread
                    print("Failed to fetch status: \(error.localizedDescription)")
                
                    self.status = self.initialStatus // Reset to initial status on error
                }
                print(error)
                print(result)
            }
        }
    }
    
    func updateTimerRate(to newRate: TimeInterval) {
        // Stop old timer
        timer.upstream.connect().cancel()
        
        // Create new one with new rate
        timer = Timer.publish(every: newRate, on: .main, in: .common).autoconnect()
    }
    
    static func sendCommand<V: Encodable>(ip: String, port: Int, route: String, data: V) {
        NetworkManager.postRequest(ip: ip, port: port, route: route, value: data) { success in
            DispatchQueue.main.async {
                if success {
                    print("POST request succeeded")
                } else {
                    print("POST request failed")
                }
            }
        }
    }
}

// Robot status object
class RobotStatusObject: BaseStatusObject<RobotStatus> {

    init() {
        super.init(initialStatus: RobotStatus(), statusRoute: "/robot_status")
    }
    struct setMotionCommand : Encodable {
        let twist: Twist
    }
    
    struct setPIDToggleCommand : Encodable {
        let toggle: Bool
    }

    static func setMotion(ip: String, port: Int, twist : Twist) {
        print("Setting motion to: \(twist)")
        sendCommand(ip: ip, port: port, route: "/motion", data: setMotionCommand(twist: twist))
    }
    
    static func setPIDToggle(ip: String, port: Int, toggle : Bool) {
        print("Setting PID toggle to: \(toggle)")
        sendCommand(ip: ip, port: port, route: "/pid_toggle", data: setPIDToggleCommand(toggle: toggle))
    }

}
