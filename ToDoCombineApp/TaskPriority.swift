//
//  TaskPriority.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 30.03.2023.
//

import Foundation
import SwiftUI

enum TaskPriority: String, Identifiable, CaseIterable, Comparable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var id: String {
        return self.rawValue
    }
    
    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
            switch (lhs, rhs) {
            case (.medium, .high), (.low, .high), (.low, .medium):
                return true
            default:
                return false
            }
        }
}

extension TaskPriority {
    var priorityColor: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        }
    }
}
