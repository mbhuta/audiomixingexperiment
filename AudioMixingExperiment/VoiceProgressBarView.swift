//
//  VoiceProgressBarView.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 3/6/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

class VoiceProgressBarView: UIView {
    
    var barWidth: CGFloat = 12
    var barPath: UIBezierPath!
    
    fileprivate var backgroundLayer: CAShapeLayer?
    fileprivate var progressLayer: CAShapeLayer?
    
    var viewFrame: CGRect {
        get {
            return self.frame
        }
        set {
            self.frame = newValue
            self.setupProgressBar()
        }
    }
    
    func initProgressBar() {
        self.barPath = UIBezierPath()
        self.initBackgroundLayer()
        self.initProgressLayer()
    }
    
    func initBackgroundLayer() {
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer?.strokeColor = UIColor.gray.cgColor
        self.backgroundLayer?.lineWidth = self.barWidth
        self.backgroundLayer?.lineCap = .round
        self.layer.addSublayer(self.backgroundLayer!)
    }
    
    func initProgressLayer() {
        self.progressLayer = CAShapeLayer()
        self.progressLayer?.strokeColor = UIColor.systemPink.cgColor
        self.progressLayer?.lineWidth = self.barWidth
        self.progressLayer?.lineCap = .round
        self.resetProgressLayer()
        self.layer.addSublayer(self.progressLayer!)
    }
    
    func resetProgressLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.progressLayer?.removeFromSuperlayer()
        self.progressLayer?.strokeStart = 0
        self.progressLayer?.strokeEnd = 0
        CATransaction.commit()
        
        self.layer.addSublayer(self.progressLayer!)
    }
    
    func updateProgressLayer(strokeEnd: CGFloat) {
        self.progressLayer?.strokeEnd = strokeEnd
    }
    
    func setupProgressBar() {
        self.setupBarPath()
        self.setupBackgroundLayer()
        self.setupProgressLayer()
    }
    
    func setupBarPath() {
        self.barPath.removeAllPoints()
        self.barPath.move(to: CGPoint(x: self.barWidth/2, y: self.bounds.midY))
        self.barPath.addLine(to: CGPoint(x: self.frame.width - (self.barWidth/2), y: self.bounds.midY))
    }
    
    func setupBackgroundLayer() {
        self.backgroundLayer?.path = self.barPath.cgPath
    }
    
    func setupProgressLayer() {
        self.progressLayer?.path = self.barPath.cgPath
    }
}
