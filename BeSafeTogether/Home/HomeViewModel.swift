//
//  HomeViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import Combine
import Foundation
import AVFAudio

class HomeViewModel: ObservableObject {
    
    @Published var isGpsEnabled = true
    //    @Published var isContactsSet = true
    //    @Published var isStopWordsSet = true
    
    @Published var isRecording = false
    var audioRecorder: AVAudioRecorder?
    var recordCount = 0
    var timer: Timer? = nil
    
    var isContactsSet: Bool {
        guard let userWords = WordsAndContactsStorage.shared.contacts else { return false }
        return !userWords.contacts.isEmpty
    }
    
    var isStopWordsSet: Bool {
        guard let userWords = WordsAndContactsStorage.shared.words else { return false }
        return !userWords.words.isEmpty
    }
    
    var isRequirementsMet: Bool {
        return isGpsEnabled && isContactsSet && isStopWordsSet
    }
    
    func startRecording() {
        let filename = getDocumentsDirectory().appendingPathComponent("recording\(self.recordCount).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder?.record()
            print("Started recording: \(filename)")
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
            self.audioRecorder = nil
            print("Stopped recording")
            let audioFileURL = getDocumentsDirectory().appendingPathComponent("recording\(self.recordCount).m4a")
            APIManager.shared.sendTranscriptionRequest(audioFileURL: audioFileURL)
        } else {
            print("Tried to stop recording, but audioRecorder was nil.")
        }
    }
    
    func getFullRecordingPath() -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let recordingFileName = "recording.mp3" // Update the file name and extension if needed
        
        return documentsDirectory.appendingPathComponent(recordingFileName)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
