//
//  CSAudioData.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 12/14/19.
//  Copyright © 2019 Dirtcube Interactive. All rights reserved.
//

import Foundation
import AVFoundation

class CSAudioData {
    
    var audioFileURL: URL? {
        didSet {
            if let url = self.audioFileURL {
                self.audioFile = try? AVAudioFile(forReading: url)
            }
        }
    }
    
    var audioFile: AVAudioFile? {
        didSet {
            if let file = self.audioFile {
                self.audioFormat = file.fileFormat
                self.processingFormat = file.processingFormat
                self.sampleCount = file.length
                self.sampleRate = Float(self.processingFormat?.sampleRate ?? 44100)
                self.durationSeconds = Float(self.sampleCount)/self.sampleRate
            }
        }
    }
    
    var audioFormat: AVAudioFormat?
    var processingFormat: AVAudioFormat?
    
    var sampleRate: Float = 0
    var durationSeconds: Float = 0
    var sampleCount: AVAudioFramePosition = 0
    
}
