//
//  StringExtension.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation
extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
