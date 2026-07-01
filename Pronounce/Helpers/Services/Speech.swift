//
//  Speech.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import AVFoundation
import NaturalLanguage
import Combine

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private var synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String, language: Languages) {
        stop()
        
        // Ensure the hardware is ready for high-quality audio
        setupAudioSession()

        let allVoices = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language == language.rawValue }

        let voice = allVoices.first { $0.quality == .premium && $0.gender == .male }
                ?? allVoices.first { $0.quality == .enhanced && $0.gender == .male }
                ?? allVoices.first { $0.quality == .premium }
                ?? allVoices.first { $0.quality == .enhanced }
                ?? allVoices.first { $0.gender == .male }
                ?? AVSpeechSynthesisVoice(language: language.rawValue)

        let utterance = AVSpeechUtterance(string: text)
        
        // Strict settings for maximum clarity
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
    }

    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // .playback ignores the silent switch and prioritizes audio quality
            try session.setCategory(.playback, mode: .spokenAudio, options: [])
            try session.setPreferredSampleRate(44100.0)
            try session.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
    }
    
    // MARK: - Delegate Logic
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Ensure UI updates on the main thread
        DispatchQueue.main.async { self.isSpeaking = true }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if !synthesizer.isSpeaking {
            DispatchQueue.main.async { self.isSpeaking = false }
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
}
