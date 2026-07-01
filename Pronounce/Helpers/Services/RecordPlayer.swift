//
//  RecordPlayer.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import SwiftUI
import AVFoundation
import Combine

class RecordPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    private var player: AVAudioPlayer?
    
    @Published var isPlaying: Bool = false
    
    func play(recordData: Data) {
        player?.stop()
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            
            player = try AVAudioPlayer(data: recordData)
            
            // 3. Set the delegate to self
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            
            // Update state
            withAnimation {
                self.isPlaying = true
            }
            
        } catch {
            print("Cannot play audio file: \(error.localizedDescription)")
            self.isPlaying = false
        }
    }
    
    func stop() {
        guard let player = player, player.isPlaying else { return }
        player.stop()
        
        // Update state manually if forced stop
        withAnimation {
            self.isPlaying = false
        }
    }
    
    // 4. Implement the Delegate Method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // This runs automatically when audio reaches the end
        print("Audio finished playing automatically")
        
        withAnimation {
            self.isPlaying = false
        }
    }
}
