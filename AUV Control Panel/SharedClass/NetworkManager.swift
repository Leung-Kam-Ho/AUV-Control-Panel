
// CLP_Inspection_Robot_Panel/EnvironmentObject/NetworkManager.swift
import Foundation
import os

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    static func createURL(ip: String, port: Int, route: String) -> URL {
        URL(string: "http://\(ip)\(route)") ?? URL(string: "http://127.0.0.1")!
    }
    

    static func getRequest<T: Decodable>(ip: String, port: Int, route: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = NetworkManager.createURL(ip: ip, port: port, route: route)
        let request = URLRequest(url: url, timeoutInterval: 1)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    static func postRequest<T: Encodable>(ip: String, port: Int, route: String, value: T, completion: ((Bool) -> Void)? = nil) {
        let url = createURL(ip: ip, port: port, route: route)
        var request = URLRequest(url: url, timeoutInterval: 1)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let message = ["value": value]
        request.httpBody = try? JSONEncoder().encode(message)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            completion?(error == nil && data != nil)
        }
        task.resume()
    }
}


//// Example usage in a device environment object
//NetworkManager.shared.getRequest(ip: "192.168.10.5", port: 8000, route: "/robot") { (result: Result<RobotStatus, Error>) in
//    switch result {
//    case .success(let status):
//        DispatchQueue.main.async {
//            self.status = status
//        }
//    case .failure(let error):
//        print(error)
//    }
//}
//struct MyData: Encodable {
//    let name: String
//    let age: Int
//}
//
//let data = MyData(name: "Alice", age: 30)
//NetworkManager.shared.postRequest(ip: "192.168.10.5", port: 8000, route: "/submit", value: data) { success in
//    DispatchQueue.main.async {
//        if success {
//            print("POST request succeeded")
//        } else {
//            print("POST request failed")
//        }
//    }
//}
