//
//  Language.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/20/26.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case italian = "it"
    case german = "de"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .italian: return "Italian"
        case .german: return "German"
        }
    }
}
