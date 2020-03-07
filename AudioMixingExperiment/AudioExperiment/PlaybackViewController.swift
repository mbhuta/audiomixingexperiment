//
//  PlaybackViewController.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 12/14/19.
//  Copyright © 2019 Dirtcube Interactive. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {

    @IBOutlet weak var playerControlsView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUI() {
        
        playerControlsView.layer.cornerRadius = playerControlsView.bounds.height/4
        playerControlsView.clipsToBounds = true
        
    }

}
