//
//  EditingViewController.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {

    //var mediaImagePreview: UIImageView!
    var mediaPreview: MediaPreviewView!
    
    var voiceButton: UIButton!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupMediaPreview()
        self.setupButton()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setSubviewFrames()
        self.customizeSubviews()
    }
    
}

// MARK:- Media Setup
extension EditingViewController {
    
    func setSubviewFrames() {
        self.mediaPreview.viewFrame = self.view.getStandard9By16Rect()
        self.voiceButton.frame = self.view.getButtonRect(position: .topRight, padding: 16)
    }
    
    func customizeSubviews() {
        self.voiceButton.round()
    }
    
    func setupMediaPreview() {
        self.mediaPreview = MediaPreviewView()
        self.mediaPreview.set(image: UIImage(named: "deadpool")!)
        self.view.addSubview(mediaPreview)
    }
    
    func setupButton() {
        self.voiceButton = UIButton()
        self.voiceButton.backgroundColor = .systemTeal
        self.voiceButton.addTarget(self, action: #selector(selectVoiceMode(_:)), for: .touchUpInside)
        self.view.addSubview(self.voiceButton)
    }
    
}

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
