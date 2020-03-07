//
//  EditingViewController.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

// MARK: Main Class Declaration and Lifecycle Functionality
class EditingViewController: UIViewController {
    
    var voiceButton: UIButton!
    
    var mediaPreview: MediaPreviewView!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMediaPreview()
        self.initButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setSubviewFrames()
        self.setSubviewCustomizations()
    }
    
}

// MARK: Media and UI Setup
extension EditingViewController {
    
    func setSubviewFrames() {
        self.mediaPreview.viewFrame = self.view.getStandard9By16Rect()
        self.voiceButton.frame = self.view.getButtonRect(position: .topRight, padding: 16)
    }
    
    func setSubviewCustomizations() {
        self.voiceButton.round()
    }
    
    func initMediaPreview() {
        self.mediaPreview = MediaPreviewView()
        self.mediaPreview.set(image: UIImage(named: "deadpool")!)
        self.view.addSubview(mediaPreview)
    }
    
    func initButton() {
        self.voiceButton = UIButton()
        self.voiceButton.backgroundColor = .systemTeal
        self.voiceButton.addTarget(self, action: #selector(selectVoiceMode(_:)), for: .touchUpInside)
        self.view.addSubview(self.voiceButton)
    }
    
}

// MARK: Voice Mode Functionality
extension EditingViewController: VoiceViewDelegate {
    
    @objc func selectVoiceMode(_ sender: UIButton) {
        let voiceView = VoiceViewController(nibName: "VoiceViewController", bundle: Bundle.main)
        voiceView.modalPresentationStyle = .custom
        voiceView.delegate = self
        
        self.present(voiceView, animated: true, completion: nil)
    }
    
    func voiceView(willAppear sender: VoiceViewController) {
        self.voiceButton.isHidden = true
    }
    
    func voiceView(willDisappear sender: VoiceViewController) {
        self.voiceButton.isHidden = false
    }
    
}
