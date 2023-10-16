//
//  SupportedLanguages.swift
//  VoiceCommands
//
//  Created by iTech on 13/10/23.
//

import Foundation

struct LanguageConfig {
    static let supportedLanguage = SupportedLanguages.english
}

enum SupportedLanguages: String {
    
    // Add more languages here
    
    case english = "en-US"
    
    var numberDictionary: [String: String] {
        switch self {
            
        case .english:
            return ["zero": "0",
                    "one": "1",
                    "two": "2",
                    "three": "3",
                    "four": "4",
                    "five": "5",
                    "six": "6",
                    "seven": "7",
                    "eight": "8",
                    "nine": "9"]
        }
    }
}
