//
//  MediaView.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 3/4/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

class MediaPreviewView: UIView {
    
    fileprivate var previewImageView: UIImageView? = nil
    
    var viewFrame: CGRect {
        get {
            return self.frame
        }
        set {
            self.frame = newValue
            self.previewImageView?.frame = frame
        }
    }
    
    func set(image: UIImage) {
        if self.previewImageView == nil {
            self.initPreviewImageView()
        }
        
        previewImageView?.image = image
    }
    
    func initPreviewImageView() {
        self.previewImageView = UIImageView(frame: self.frame)
        self.previewImageView?.clipsToBounds = true
        self.previewImageView?.center = self.center
        self.previewImageView?.contentMode = .scaleAspectFit
        self.addSubview(self.previewImageView!)
    }
    
    func clear() {
        self.previewImageView?.removeFromSuperview()
        self.previewImageView = nil
    }
    
}
