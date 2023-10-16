//
//  SpeechCoordinator+Commands.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation
import Speech

extension SpeechCoordinator {
    
    enum VoiceModuleOperationState {
        case listenOnlyForCommands
        case listenForCommandsAndValues
    }
    
    func processTranscription(_ bestTranscription: SFTranscription) {
        
        transcriptionReceived(bestTranscription.formattedString)
        
        let transcription = bestTranscription.formattedString
        
        switch voiceModuleState {
        case .listenOnlyForCommands:
            if let command = detectCommand(transcription) {
                triggerCommand(command: command)
            }
            
        case .listenForCommandsAndValues:
            if let command = detectCommand(transcription) {
                triggerCommand(command: command)
            } else {
                processForValues(transcription)
            }
        }
    }
    
    private func processForValues(_ transcription: String) {
        guard let lastCommand = outputArray.last else {
            return
        }
        outputArray.removeLast()
        
        if let last = processingArray.last,
           last.command != BackCommand().commandString {
            processingArray.removeLast()
        }
        
        let numberDict = LanguageConfig.supportedLanguage.numberDictionary
        
        var updatedTranscription = transcription.lowercased()
        for (key, value) in numberDict {
            updatedTranscription = updatedTranscription.replacingOccurrences(of: key, with: value)
        }
        
        let model = VoiceCommandModel(command: lastCommand.command, value: updatedTranscription.digits)
        outputArray.append(model)
        processingArray.append(model)
        
        commandOutputHandler(outputArray, processingArray)
    }
    
    private func detectCommand(_ transcription: String) -> VoiceCommand? {
        
        for command in commandsToRecognise {
            if transcription.lowercased().contains(command.commandString.lowercased()) {
                
                return command
            }
        }
        return nil
    }
    
    private func triggerCommand(command: VoiceCommand) {
        
        voiceCommandRecognised(command.commandString)
        
        let lastValue = outputArray.last?.value
        
        command.processCommand(processingArray: &processingArray, outputArray: &outputArray)
        
        switch command {
        case _ as ResetCommand:
            voiceModuleState = .listenOnlyForCommands
            systemIsWaitingForCommand()
            
        case _ as BackCommand:
            if let lastValue = lastValue,
               !lastValue.isEmpty {// remove number value
                voiceModuleState = .listenForCommandsAndValues
            } else {
                voiceModuleState = .listenOnlyForCommands
                systemIsWaitingForCommand()
            }
        default:
            voiceModuleState = .listenForCommandsAndValues
        }
        
        commandOutputHandler(outputArray, processingArray)
        
        restartAudioBuffer()
    }
}
