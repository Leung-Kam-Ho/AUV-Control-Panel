//swift
//  CLP_Inspection_Robot_Panel
//
//  Created by Kam Ho Leung on 26/5/2025.
//

import Foundation
import SwiftUI
import os
internal import Combine


enum AutoMode_segment: String, CaseIterable {
    case Manual, Standing, Lauch, Baffle, Testing
}

// Base class for status objects to avoid code duplication
class BaseStatusObject<T>: ObservableObject where T: Decodable & Equatable {
    let objectWillChange = ObservableObjectPublisher()
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
            }
        }
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
