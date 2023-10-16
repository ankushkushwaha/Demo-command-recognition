//
//  HomeViewModel.swift
//  VoiceCommands
//
//  Created by Ankush on 29/09/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var cellViewModel: TableCellViewModel?
    @Published var statusLabelText: String?
    
    private let speech = SpeechCoordinator.shared
    
    private var transcriptionString: String = ""
    private var output: String = ""
    private var currentStatus: String = ""
    private var allCommandHistory: String = ""
    
    private func updateCellViewModel() {
        cellViewModel = TableCellViewModel(speechText: transcriptionString,
                                           outputText: output,
                                           allCommandHisory: allCommandHistory,
                                           currentStatus: currentStatus)
        
    }
    
    func requestSpeechAuthorization () {
        speech.requestAuthorization()
    }
    
    func setupSpeech() {
        
        speech.initialize()
        
        speech.voiceCommandRecognised = { [weak self] command in
            self?.statusLabelText = "Voice Module State\n\nListning to command: \(command)"
        }
        
        speech.systemIsWaitingForCommand = { [weak self] in
            self?.statusLabelText = "Voice Module State\n\nWaiting for command...."
        }
        
        speech.transcriptionReceived = { [weak self] transcription in
            self?.transcriptionString = transcription
            
            self?.updateCellViewModel()
        }
        
        speech.commandOutputHandler = { [weak self] (outputArray, allCommandHistoryArray) in
            
            if let lastCommand = allCommandHistoryArray.last?.command,
               let lastValue = allCommandHistoryArray.last?.value {
                self?.currentStatus = "Status: \(String(describing: lastCommand))\nParameters: \(String(describing: lastValue))"
            }
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(outputArray)
                let outPutString: String? = String(data: data, encoding: .utf8)
                self?.output = outPutString ?? ""
                
                let historyData = try encoder.encode(allCommandHistoryArray)
                let historyString: String? = String(data: historyData, encoding: .utf8)
                self?.allCommandHistory = historyString ?? ""
                
                self?.updateCellViewModel()
                
            } catch {
                print(error)
            }
        }
    }
}
