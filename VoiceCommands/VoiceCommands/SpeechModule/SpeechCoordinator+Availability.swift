//
//  SpeechCoordinator+Availability.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import Foundation
import Speech

extension SpeechCoordinator {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            debugPrint("\(SpeechCoordinator.identifier) availabilityDidChange \(DebuggingIdentifiers.actionOrEventSucceded) Speech recognition available.")
            self.restartAudioBuffer()
        } else {
            debugPrint("\(SpeechCoordinator.identifier) availabilityDidChange \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition not available.")
        }
    }
}
