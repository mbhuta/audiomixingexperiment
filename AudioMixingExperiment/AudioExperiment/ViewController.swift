//
//  ViewController.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 12/13/19.
//  Copyright © 2019 Dirtcube Interactive. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet weak var playerControlsView: UIVisualEffectView!
    
    private var engine: AVAudioEngine = AVAudioEngine()
    private var mixer: AVAudioMixerNode = AVAudioMixerNode()
    
    private var audioPlayer1: AVAudioPlayerNode?
    private var audioPlayer2: AVAudioPlayerNode?
    
    private var fileName1: String = "country_roads"
    private var fileFormat1: String = "mp3"
    
    private var fileName2: String = "soundbyte1"
    private var fileFormat2: String = "wav"
    
    private var audioData1: CSAudioData = CSAudioData()
    private var audioData2: CSAudioData = CSAudioData()
    
    @IBAction func playAudio(_ sender: Any) {
        if let player1 = self.audioPlayer1, let player2 = self.audioPlayer2 {
            if player1.isPlaying { player1.pause() } else { player1.play() }
            if player2.isPlaying { player2.pause() } else { player2.play() }
        }
    }
    
    @IBAction func muxAudio(_ sender: Any) {
        self.stopAudio()
        self.enableManualRendering()
        self.prepareOutputDestinationsAndRender()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupAudio()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUI() {
        
        self.playerControlsView.layer.cornerRadius = playerControlsView.bounds.height/4
        self.playerControlsView.clipsToBounds = true
        print("UI Setup for source file view controller complete");
    }

    func setupEngineAndMixer() {
        self.engine.attach(self.mixer)
        self.engine.connect(self.mixer, to: self.engine.outputNode, format: nil)
        print("Mixer and engine setup complete");
    }
    
    func startEngine() {
        try? self.engine.start()
    }
    
    func setupPlayerNode(player: inout AVAudioPlayerNode?, audioData: CSAudioData?) {
        guard let audioData = audioData else { fatalError("Cannot load nil audio data into player") }
        
        player = AVAudioPlayerNode()
        
        self.engine.attach(player!)
        self.engine.connect(player!, to: self.mixer, format: audioData.processingFormat)
        print("Player node setup complete");
    }

//    func setupAudio() {
//        let path1 = Bundle.main.path(forResource: fileName1, ofType: fileFormat1)
//        let fileURL1 = URL.init(fileURLWithPath: (path1?.removingPercentEncoding)!)
//        let file1: AVAudioFile = try! AVAudioFile.init(forReading: fileURL1)
//        let buffer1: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: file1.processingFormat, frameCapacity: AVAudioFrameCount(Float(file1.length)))!
//        try! file1.read(into: buffer1)
//
//        let path2 = Bundle.main.path(forResource: fileName2, ofType: fileFormat2)
//        let fileURL2 = URL.init(fileURLWithPath: (path2?.removingPercentEncoding)!)
//        let file2 = try! AVAudioFile.init(forReading: fileURL2)
//        let buffer2: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: file2.processingFormat, frameCapacity: AVAudioFrameCount(Float(file2.length)))!
//        try! file2.read(into: buffer2)
//
//        self.engine.attach(self.mixer)
//        self.engine.connect(self.mixer, to: self.engine.outputNode, format: nil)
//
//        //try! self.engine.start()
//
//        self.engine.attach(audioPlayer1)
//        self.engine.connect(audioPlayer1, to: self.mixer, format: file1.processingFormat)
//
//        self.engine.attach(audioPlayer2)
//        self.engine.connect(audioPlayer2, to: self.mixer, format: file2.processingFormat)
//
//        try! self.engine.start()
//
//        // audioPlayer1.scheduleFile(file1, at: nil, completionHandler: nil)
//        audioPlayer1.scheduleBuffer(buffer1, at: nil, options: .loops, completionHandler: nil)
//
//        // audioPlayer2.scheduleFile(file2, at: nil, completionHandler: nil)
//        audioPlayer2.scheduleBuffer(buffer2, at: nil, options: .interrupts, completionHandler: nil)
//
//        audioPlayer1.volume = 0.1
//        audioPlayer2.volume = 1
//    }
    
    func setupAudio() {
        self.setupCSAudioData(audioData: self.audioData1, fileName: self.fileName1, ofType: self.fileFormat1)
        self.setupCSAudioData(audioData: self.audioData2, fileName: self.fileName2, ofType: self.fileFormat2)
        self.setupEngineAndMixer()
        
        self.setupPlayerNode(player: &self.audioPlayer1, audioData: self.audioData1)
        self.setupPlayerNode(player: &self.audioPlayer2, audioData: self.audioData2)
        
        self.audioPlayer1?.scheduleFile(self.audioData1.audioFile!, at: nil, completionHandler: nil)
        self.audioPlayer2?.scheduleFile(self.audioData2.audioFile!, at: nil, completionHandler: nil)
        print("Audio scheduling complete")
        
        self.startEngine()
    }
    
    func setupCSAudioData(audioData: CSAudioData?, fileName: String, ofType format: String) {
        guard let data = audioData
            else { fatalError("Received nil audio data during setup") }
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: format)
            else { fatalError("File \(fileName).\(format) not found!") }
        
        data.audioFileURL = URL(fileURLWithPath: (filePath.removingPercentEncoding)!)
        print("Audio Data setup complete")
    }
    
    
    func playAudio() {
        if !self.engine.isRunning { try? self.engine.start() }
        
        self.audioPlayer1?.play(at: nil)
        self.audioPlayer2?.play(at: nil)
    }
    
    func pauseAudio() {
        if let player1 = self.audioPlayer1, player1.isPlaying { player1.pause() }
        if let player2 = self.audioPlayer2, player2.isPlaying { player2.pause() }
    }
    
    func stopAudio() {
        if let player1 = self.audioPlayer1, player1.isPlaying { player1.stop() }
        if let player2 = self.audioPlayer2, player2.isPlaying { player2.stop() }
        if self.engine.isRunning { self.engine.stop() }
    }
    
    func enableManualRendering() {
        do {
            let maxFrames: AVAudioFrameCount = 4096 // AVAudioFrameCount(self.audioData1.sampleCount)
            try engine.enableManualRenderingMode(.offline, format: self.audioData1.processingFormat!, maximumFrameCount: maxFrames)
        } catch {
            fatalError("Enabling manual rendering mode failed: \(error.localizedDescription).")
        }
        
        do {
            try self.engine.start()
            self.audioPlayer1?.play(at: nil)
            self.audioPlayer2?.play(at: nil)
        } catch {
            fatalError("Unable to start audio engine: \(error.localizedDescription).")
        }
    }
    
    func prepareOutputDestinationsAndRender() {
        let buffer = AVAudioPCMBuffer(pcmFormat: self.engine.manualRenderingFormat, frameCapacity: self.engine.manualRenderingMaximumFrameCount)
        let outputFile: AVAudioFile
        
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let outputURL = documentsURL?.appendingPathComponent("voiceover_processed.mp3")
            print(outputURL!.absoluteString)
            
            outputFile = try AVAudioFile(forWriting: outputURL!, settings: audioData1.audioFormat!.settings)
        } catch {
            fatalError("Unable to open output audio file: \(error.localizedDescription).")
        }
        
        self.renderAudio(buffer: buffer, outputFile: outputFile)
    }
    
    func renderAudio(buffer: AVAudioPCMBuffer?, outputFile: AVAudioFile?) {
        guard let buffer = buffer else { fatalError("Buffer cannot be nil for renderAudio call") }
        guard let outputFile = outputFile else { fatalError("Output File cannot be nil for renderAudio call") }
        
        while self.engine.manualRenderingSampleTime < self.audioData1.sampleCount {
            do {
                let frameCount = self.audioData1.sampleCount - self.engine.manualRenderingSampleTime
                let framesToRender = min(AVAudioFrameCount(frameCount), buffer.frameCapacity)
                
                let status = try self.engine.renderOffline(framesToRender, to: buffer)
                switch status {
                    case .success:
                        // The data rendered successfully. Write it to the output file.
                        try outputFile.write(from: buffer)
                        print("Successfully wrote \(framesToRender) frames to file")
                    case .insufficientDataFromInputNode:
                        // Applicable only when using the input node as one of the sources.
                        print("Manual rendering status: \(status)")
                        break
                    case .cannotDoInCurrentContext:
                        // The engine couldn't render in the current render call.
                        // Retry in the next iteration.
                        print("Manual rendering status: \(status), retrying in next iteration")
                        break
                    case .error:
                        // An error occurred while rendering the audio.
                        fatalError("The manual rendering failed with status \"error\"")
                    default:
                        print("Manual rendering encountered unknown status: \(status)")
                }
            } catch {
                fatalError("The manual rendering failed: \(error).")
            }
        }
        
        print("Successfully rendered audio!")
        self.stopAudio()
        self.performSegue(withIdentifier: "muxingSegue", sender: self)
    }
}

