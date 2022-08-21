//
//  TabBarItem.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home, favorites, profile, messages
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .favorites:
            return "heart"
        case .profile:
            return "person"
        case .messages:
            return "message"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "HOME"
        case .favorites:
            return "FAVORITES"
        case .profile:
            return "PROFILE"
        case .messages:
            return "MESSAGES"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return Color.red
        case .favorites:
            return Color.blue
        case .profile:
            return Color.green
        case .messages:
            return Color.orange
        }
    }
}
