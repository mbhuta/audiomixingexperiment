//
//  SoundbyteHandleView.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 3/1/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

class SoundbyteHandleView: UIView {
    
    var panGR: UIPanGestureRecognizer!
    
    var radius: CGFloat = 20
    var thumbCenter: CGPoint {
        get {
            let x: CGFloat = self.frame.width/2
            let y: CGFloat = self.frame.height - self.radius
            return CGPoint(x: x, y: y)
        }
    }
    var iconRect: CGRect {
        get {
            let width: CGFloat = 24
            let height: CGFloat = 24
            let x: CGFloat = self.thumbCenter.x - width/2
            let y: CGFloat = self.thumbCenter.y - height/2
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    var icon: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.icon = UIImage(named: "24-trash-white")!.withTintColor(UIColor.black)
        self.addShadow()
        self.addGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureRecognizers() {
        self.panGR = UIPanGestureRecognizer()
        self.panGR.addTarget(self, action: #selector(self.handlePan(_:)))
        self.addGestureRecognizer(self.panGR)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)
        
        self.center.x += translation.x
        
        recognizer.setTranslation(.zero, in: self.superview)
        
    }
    
    // MARK: Custom view drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        
        self.drawHandleShape(context: context)
        self.drawImage(context: context)
    }
    
    func drawHandleShape(context: CGContext) {
        let Pi = CGFloat.pi
        let cursorWidth: CGFloat = 2
        
        let startAngleZero: CGFloat = 0 - (Pi/2)
        let startAngleDiff: CGFloat = asin((cursorWidth/2)/radius)
        
        let startAngle: CGFloat = startAngleZero + startAngleDiff
        let endAngle: CGFloat = startAngleZero - startAngleDiff + (2 * Pi)
        
        // Calculate the coordinates on the circle from where the thumb drawing begins
        let y: CGFloat = sin(startAngle) * radius
//        let x: CGFloat = sqrt((radius * radius) - (y * y))
        
        // Draw the circular part (i.e. 'thumb') of the handle
        let handlePath: UIBezierPath = UIBezierPath(arcCenter: thumbCenter,
                                                    radius: radius,
                                                    startAngle: startAngle,
                                                    endAngle: endAngle,
                                                    clockwise: true)
        
//        handlePath.move(to: CGPoint(x: (thumbCenter.x + x), y: (thumbCenter.y + y)))
//        handlePath.addArc(withCenter: thumbCenter,
//                          radius: radius,
//                          startAngle: startAngle,
//                          endAngle: endAngle,
//                          clockwise: true)
        
        // Draw the cursor (aka 'tail') part of the handle
        handlePath.addLine(to: CGPoint(x: handlePath.currentPoint.x, y: cursorWidth/2))
        handlePath.addArc(withCenter: CGPoint(x: handlePath.currentPoint.x + cursorWidth/2, y: handlePath.currentPoint.y),
                          radius: cursorWidth/2,
                          startAngle: Pi,
                          endAngle: (2 * Pi),
                          clockwise: true)
        handlePath.addLine(to: CGPoint(x: handlePath.currentPoint.x, y: thumbCenter.y + y))
        
        // Close and fill the shape drawn by the path
        handlePath.close()
        handlePath.fill()
    }
    
    func drawImage(context: CGContext) {
        self.icon.draw(in: self.iconRect)
    }
    
    // MARK: UNUSED METHODS Do not delete, could use for reference
    func setupThumbLayer() {
        let circlePath = UIBezierPath(arcCenter: .zero,
                                      radius: self.radius,
                                      startAngle: 0, endAngle: 2 * CGFloat.pi,
                                      clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.systemTeal.cgColor
        circleLayer.position = self.thumbCenter
        self.layer.addSublayer(circleLayer)
    }
    
    func setupCursorLayer() {
        let lineWidth: CGFloat = 4
        let cursorPath = UIBezierPath()
        cursorPath.move(to: CGPoint(x: self.frame.width/2, y: self.frame.height - (2 * self.radius)))
        cursorPath.addLine(to: CGPoint(x: self.frame.width/2, y: lineWidth/2))
        let cursorLayer = CAShapeLayer()
        cursorLayer.lineCap = .round
        cursorLayer.strokeColor = UIColor.white.cgColor
        cursorLayer.lineWidth = lineWidth
        cursorLayer.path = cursorPath.cgPath
        self.layer.addSublayer(cursorLayer)
    }
    
}
