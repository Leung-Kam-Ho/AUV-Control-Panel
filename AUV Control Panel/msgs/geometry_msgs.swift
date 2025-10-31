//
//  geometry_msgs.swift
//  AUV Control Panel
//
//  Created by KamHo on 31/10/25.
//

import Foundation

struct Vector3: Codable, Hashable {
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    
    static func * (lhs: Vector3, rhs: Double) -> Vector3 {
        return Vector3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    
    static func * (lhs: Double, rhs: Vector3) -> Vector3 {
        return rhs * lhs // reuse the other operator
    }
}

struct Twist: Codable, Hashable {
    var linear: Vector3 = Vector3()
    var angular: Vector3 = Vector3()
    
    static func * (lhs: Twist, rhs: Double) -> Twist {
        return Twist(linear: lhs.linear * rhs, angular: lhs.angular * rhs)
    }
    
    static func * (lhs: Double, rhs: Twist) -> Twist {
        return rhs * lhs // reuse the same logic
    }
}
