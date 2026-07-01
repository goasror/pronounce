//
//  Recorder.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import AVFoundation

class Recorder: NSObject, AVAudioRecorderDelegate {
    func checkPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                completion(granted)
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
        }
    }
    
    var recordingUrl: URL?
    var duration: Double?
    var recorder: AVAudioRecorder?
    func record() {
        checkPermission { isGranted in
            if !isGranted {
                print("Mic access is required.")
                return
            }
            do {
                let recorderSession = AVAudioSession.sharedInstance()
                try recorderSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                try recorderSession.setActive(true)
                
                let filePathName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let recordingName = filePathName.appendingPathComponent("temporary.m4a")
                self.recordingUrl = recordingName
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 22050.0,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue,
                    AVEncoderBitRateKey: 32000
                ]
                
                self.recorder = try AVAudioRecorder(url: recordingName, settings: settings)
                self.recorder?.record()
            } catch {
                print("Coudn't record for God's sake!")
            }
        }
        
    }
    
    func stop(cancel: Bool = false) -> Data? {
        duration = recorder?.currentTime
        recorder?.stop()
        guard let url = recordingUrl else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Couldn't convert record to data.")
            return nil
        }
    }
    
    func cancel() {
        recorder?.stop()
        do {
            guard let recordingUrl else { return }
            try FileManager.default.removeItem(at: recordingUrl)
        } catch {
            return
        }
    }
}
