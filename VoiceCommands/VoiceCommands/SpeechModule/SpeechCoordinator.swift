//
//  SpeechCoordinator.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation
import UIKit
import Speech

class SpeechCoordinator: NSObject, SFSpeechRecognizerDelegate {

    var systemIsWaitingForCommand: (() -> Void) = {}
    var transcriptionReceived: ((String) -> Void) = {_ in }
    var voiceCommandRecognised: ((String) -> Void) = {_ in }
    var commandOutputHandler: ((_ outputArray: [VoiceCommandModel],
                                _ historyArray: [VoiceCommandModel]) -> Void) = {_,_  in }

    var voiceModuleState = VoiceModuleOperationState.listenOnlyForCommands
    
    var outputArray: [VoiceCommandModel] = []
    var processingArray: [VoiceCommandModel] = []

    var commandsToRecognise = VoiceCommandConfig().commandsToRecognise
    
    static let identifier: String = "[SpeechCoordinator]"
    static let shared: SpeechCoordinator = SpeechCoordinator()

    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: LanguageConfig.supportedLanguage.rawValue))!

    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?

    let audioEngine = AVAudioEngine()
    var audioRestartTimer: Timer?
    var startAudioIntervalTimer: Timer?
    let restartTimeInterval: TimeInterval = 60

    func initialize() {
        speechRecognizer.delegate = self
    }

    func requestAuthorization() {
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in

            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    debugPrint("\(SpeechCoordinator.identifier) requestAuthorization \(DebuggingIdentifiers.actionOrEventSucceded) Speech recognition authorized.")
                                        
                    self?.restartAudioBuffer()

                    self?.systemIsWaitingForCommand()

                case .denied:
                    debugPrint("\(SpeechCoordinator.identifier) requestAuthorization \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition authorization denied.")
                case .restricted:
                    debugPrint("\(SpeechCoordinator.identifier) requestAuthorization \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition restricted.")
                case .notDetermined:
                    debugPrint("\(SpeechCoordinator.identifier) requestAuthorization \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition not determined.")
                default:
                    debugPrint("\(SpeechCoordinator.identifier) requestAuthorization \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition authorization defaulted.")
                }
            }
        }
    }

    func endAudioRecording() {
        // Invalidate Timer
        if let timer = audioRestartTimer, timer.isValid {
            audioRestartTimer?.invalidate()
            audioRestartTimer = nil
        }

        if let timer = startAudioIntervalTimer, timer.isValid {
            startAudioIntervalTimer?.invalidate()
        }

        // End Audio Recording
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.recognitionTask?.cancel()
            self.recognitionRequest = nil
            self.recognitionTask = nil
            self.audioEngine.inputNode.removeTap(onBus: 0)
            debugPrint("\(SpeechCoordinator.identifier) endAudioRecording \(DebuggingIdentifiers.actionOrEventSucceded) Ended Audio Recording.")
        } else {
            debugPrint("\(SpeechCoordinator.identifier) endAudioRecording \(DebuggingIdentifiers.actionOrEventFailed) Failed to End Audio Recording.")
        }
    }
}
