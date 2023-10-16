//
//  VoiceCommandExtension.swift
//  VoiceCommands
//
//  Created by Ankush on 29/09/23.
//

import Foundation

extension VoiceCommand {
    func processCommand(processingArray: inout [VoiceCommandModel],  outputArray: inout [VoiceCommandModel]) {
        
        let model = VoiceCommandModel(command: commandString, value: "")
        processingArray.append(model)
        
        outputArray.append(model)
    }
}

extension ResetCommand {
    
    func processCommand(processingArray: inout [VoiceCommandModel],
                        outputArray: inout [VoiceCommandModel]) {
        let model = VoiceCommandModel(command: commandString, value: "undefined")
        processingArray.append(model)
        
        // reset
        guard outputArray.last != nil else {
            return
        }
        outputArray.removeLast()
    }
}

extension BackCommand {
    
    func processCommand(processingArray: inout [VoiceCommandModel], outputArray: inout [VoiceCommandModel]) {
        
        let model = VoiceCommandModel(command: commandString, value: "undefined")
        processingArray.append(model)
        
        guard let lastEntry = outputArray.last,
              let value = lastEntry.value,
              let lastCommand = lastEntry.command else {
            return
        }
        
        if !value.isEmpty {// remove number value
            
            outputArray.removeLast()
            
            let model = VoiceCommandModel(command: lastCommand, value: "")
            
            outputArray.append(model)
            
        } else { // reset
            
            guard outputArray.last != nil else {
                return
            }
            outputArray.removeLast()
        }
    }
}
