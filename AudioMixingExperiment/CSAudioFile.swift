//
//  CSAudioFile.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 3/7/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import AVFoundation

class CSAudioFile {
    
    var fileFormat: AVAudioFormat?
    var processingFormat: AVAudioFormat?
    var sampleRate: Float = 0
    var durationSeconds: Float = 0
    var durationSamples: AVAudioFramePosition = 0
    
    var filePath: String? {
        didSet {
            if let path = self.filePath, self.fileURL?.path != path {
                self.fileURL = URL(fileURLWithPath: path)
            }
        }
    }
    
    var fileURL: URL? {
        didSet {
            if let url = self.fileURL {
                if self.filePath == nil { self.filePath = url.path }
                self.file = try? AVAudioFile(forReading: url)
            }
        }
    }
    
    var file: AVAudioFile? {
        didSet {
            if let file = self.file {
                self.fileFormat = file.fileFormat
                self.processingFormat = file.processingFormat
                self.sampleRate = Float(self.processingFormat?.sampleRate ?? 44100)
                self.durationSamples = file.length
                self.durationSeconds = Float(self.durationSamples)/self.sampleRate
            }
        }
    }
    
    var startFrame: AVAudioFramePosition?
    var renderTime: AVAudioTime? {
        get {
            if let startFrame = self.startFrame {
                return AVAudioTime(sampleTime: startFrame, atRate: Double(self.sampleRate))
            }
            return nil
        }
    }
    
    init(fromFileAtPath path: String) {
        self.filePath = path
    }
    
}
