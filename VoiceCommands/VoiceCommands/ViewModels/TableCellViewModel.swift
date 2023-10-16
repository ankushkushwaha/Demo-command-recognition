//
//  TableCellViewModel.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation
class TableCellViewModel {
    
    let speechText: String
    let outPutText: String
    let currentStatus: String
    let allCommandHisory: String

    init(speechText: String,
         outputText: String,
         allCommandHisory: String,
         currentStatus: String) {
        
        self.speechText =  "Current Speech\n\n\(speechText)\n"
        self.outPutText = "Final Json output\n\n\(outputText)\n"
        self.allCommandHisory = "All detected commands (Including back and reset)\n\n\(allCommandHisory)\n"
        self.currentStatus = "Current status\n\n\(currentStatus)\n"
    }
}
