//
//  VoiceCommands.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation

struct VoiceCommandConfig {
    let commandsToRecognise: [VoiceCommand] = [ResetCommand(),
                                               CodeCommand(),
                                               CountCommand(),
                                               BackCommand()]
}

protocol VoiceCommand {
    var commandString: String { get }
    func processCommand(processingArray: inout [VoiceCommandModel],  outputArray: inout [VoiceCommandModel])
}

class BackCommand: VoiceCommand {
    let commandString: String = "Back"
}

class ResetCommand: VoiceCommand {
    let commandString: String = "Reset"
}

class CodeCommand: VoiceCommand {
    let commandString: String = "Code"
}

class CountCommand: VoiceCommand {
    let commandString: String = "Count"
}


