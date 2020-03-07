//
//  AudioManager.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 3/6/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import AVFoundation

protocol AudioManagerUIDelegate {
    func audioManager(didCallForUIUpdate audioManager: AudioManager, currentTime: Float, totalTime: Float)
    func audioManager(didCompleteLoop audioManager: AudioManager)
}

class AudioManager {
    
    static let testFileName: String = "countryRoads_clip"
    static let testFileExtn: String = "mp3"
    
    var testFile: AVAudioFile? {
        didSet {
            if let file = self.testFile {
                let sampleCount = file.length
                let sampleRate = Float(file.processingFormat.sampleRate)
                self.duration = Float(sampleCount)/sampleRate
            }
        }
    }
    
    var loop: Bool = true
    
    var testBuffer: AVAudioPCMBuffer?
    
    var testDisplayLink: CADisplayLink!
    var testDelegate: AudioManagerUIDelegate!
    
    fileprivate var engine: AVAudioEngine?
    fileprivate var player: AVAudioPlayerNode?
    
    fileprivate var duration: Float = 0
    
    var isPlaying: Bool {
        get {
            guard let player = self.player else { return false }
            return player.isPlaying
        }
    }
    
    init() {
        self.initTestFile()
        self.setupEngine()
        self.scheduleAudioFiles()
    }
    
    deinit {
        self.stop()
    }
    
    @objc func updateProgressBar() {
        guard let delegate = self.testDelegate else { return }
        
        guard let nodeTime: AVAudioTime = self.player?.lastRenderTime,
        let playerTime = self.player?.playerTime(forNodeTime: nodeTime)
            else {
                self.testDisplayLink.isPaused = true
                return
        }
        
        let seconds: Float = Float(Double(playerTime.sampleTime)/playerTime.sampleRate)
        delegate.audioManager(didCallForUIUpdate: self, currentTime: seconds, totalTime: self.duration)
    }
    
    func initTestFile() {
        do {
            let fileURL = Bundle.main.url(forResource: AudioManager.testFileName, withExtension: AudioManager.testFileExtn)
            self.testFile = try AVAudioFile(forReading: fileURL!)
            self.testBuffer = AVAudioPCMBuffer(pcmFormat: self.testFile!.processingFormat,
                                               frameCapacity: AVAudioFrameCount(Float(self.testFile!.length)))
            try self.testFile!.read(into: self.testBuffer!)
            
            self.testDisplayLink = CADisplayLink(target: self, selector: #selector(self.updateProgressBar))
            self.testDisplayLink.add(to: .current, forMode: .default)
            self.testDisplayLink.isPaused = true
        } catch {
            fatalError("Unable to load the source audio file: \(error.localizedDescription).")
        }
    }
    
    func setupEngine() {
        // Init the engine and nodes
        self.engine = AVAudioEngine()
        self.player = AVAudioPlayerNode()
        
        // Attach nodes to engine
        self.engine?.attach(self.player!)
        
        // Connect nodes for processing
        self.engine?.connect(self.player!, to: self.engine!.mainMixerNode, format: self.testFile?.processingFormat)
    }
    
    func scheduleAudioFiles(){
        self.player?.scheduleFile(self.testFile!, at: nil, completionHandler: nil)
        
//        self.player?.scheduleFile(self.testFile!, at: nil, completionHandler: {
//            self.player?.stop()
//        })
        
//        self.player?.scheduleBuffer(self.testBuffer!, at: nil, options: [.interruptsAtLoop, .loops], completionHandler: {
//            //(callbackType) in
//                print("loop complete")
//        })
        
//        self.player?.scheduleFile(self.testFile!, at: nil, completionCallbackType: .dataPlayedBack, completionHandler: { (callbackType) in
//            if let delegate = self.testDelegate { delegate.audioManager(didCompleteLoop: self) }
//            self.player?.stop()
//            self.scheduleAudioFiles()
//            self.player?.play()
//        })
    }
    
    func resetPlayer() {
        self.player?.reset()
        self.player?.stop()
        
        self.scheduleAudioFiles()
        
        if loop {
            //self.player?.volume = 3
            self.player?.play()
        }
    }
    
    func stop() {
        self.player?.stop()
        self.engine?.stop()
    }
    
    func play() {
        if !self.engine!.isRunning { try! self.engine?.start() }
        
        if !self.player!.isPlaying {
            self.testDisplayLink.isPaused = false
            self.player?.play()
        }
        else {
            self.testDisplayLink.isPaused = true
            self.player?.pause()
        }
    }
    
    
}
