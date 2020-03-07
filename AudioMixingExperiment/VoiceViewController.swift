//
//  VoiceViewController.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

protocol VoiceViewDelegate: class {
    func voiceView(willAppear sender: VoiceViewController)
    func voiceView(willDisappear sender: VoiceViewController)
}

class VoiceViewController: UIViewController {
    
    weak var delegate: VoiceViewDelegate? = nil
    
    weak var playerView: UIVisualEffectView?
    weak var playButton: UIButton?
    weak var trashButton: UIButton?
    
    var progressBar: VoiceProgressBarView?
    
    var audioManager: AudioManager?

    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        self.initPlayerUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.voiceView(willAppear: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.voiceView(willDisappear: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupSubviewFrames()
        self.customizeSubviews()
    }
    
    // MARK: UI Setup Methods
    func setupSubviewFrames() {
        // TODO: Set programmatically added subview frames
        self.progressBar?.viewFrame = self.setupProgressBarFrame()
    }
    
    func customizeSubviews() {
        self.playerView?.round(cornerRadius: 8)
    }
    
    func initPlayerUI() {
        self.playerView = self.view.viewWithTag(3) as? UIVisualEffectView
        self.playButton = self.view.viewWithTag(1) as? UIButton
        self.trashButton = self.view.viewWithTag(2) as? UIButton
        
        self.progressBar = VoiceProgressBarView()
        self.progressBar?.initProgressBar()
        self.playerView?.contentView.addSubview(self.progressBar!)
        
        self.audioManager = AudioManager()
        self.audioManager?.testDelegate = self
        
        self.addPlayerActions()
    }
    
    func setupProgressBarFrame() -> CGRect {
        let width: CGFloat = self.playerView!.contentView.frame.width - (self.trashButton!.frame.width + self.playButton!.frame.width)
        let height: CGFloat = (self.playerView?.contentView.frame.height)!
        let x: CGFloat = (self.playButton?.frame.width)!
        let y: CGFloat = 0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func setupPlayerFrame() -> CGRect {
        let horizontalPadding: CGFloat = 16
        let bottomPadding: CGFloat = 24
        let width: CGFloat = self.view.frame.width - (2 * horizontalPadding)
        let height: CGFloat = 72
        let x: CGFloat = horizontalPadding
        let y: CGFloat = self.view.frame.height - (height + bottomPadding)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

// MARK: UI Button Actions and Methods
extension VoiceViewController {
    
    func addPlayerActions() {
        self.playButton?.addTarget(self, action: #selector(self.playerControlTapped(_:)), for: .touchUpInside)
        self.trashButton?.addTarget(self, action: #selector(self.playerControlTapped(_:)), for: .touchUpInside)
    }
    
    @IBAction func playerControlTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.playPauseMedia()
        case 2:
            self.trashAudio()
        default:
            break
        }
    }
    
    func playPauseMedia() {
        guard let audioManager = self.audioManager else { return }
        audioManager.play()
        
        self.playButton?.setImage((audioManager.isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")), for: .normal)
    }
    
    func trashAudio() {
        print("Delete tapped")
        self.audioManager?.stop()
        self.dismiss(animated: true, completion: nil)
    }
}

extension VoiceViewController: AudioManagerUIDelegate {
    func audioManager(didCallForUIUpdate audioManager: AudioManager, currentTime: Float, totalTime: Float) {
        let percentage: CGFloat = CGFloat(currentTime/totalTime)
        
        DispatchQueue.main.async {
            if percentage < 1.0 {
                
                    self.progressBar?.updateProgressLayer(strokeEnd: percentage)
            }
            else {
                self.audioManager?.resetPlayer()
                self.progressBar?.resetProgressLayer()
                //self.playButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    
    func audioManager(didCompleteLoop audioManager: AudioManager) {
        
    }
}
