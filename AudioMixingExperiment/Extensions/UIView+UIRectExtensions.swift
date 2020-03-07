//
//  UIView+UIRectExtensions.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

enum ScreenPosition {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

extension UIView {
    
    func getStandard9By16Rect() -> CGRect {
        let width: CGFloat = self.frame.width
        let height: CGFloat = width * (16.0/9.0)
        let x: CGFloat = 0
        let y: CGFloat = (self.frame.height - height)/2
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getButtonRect(position: ScreenPosition, padding: CGFloat = 0) -> CGRect {
        let width: CGFloat = 56
        let height: CGFloat = 56
        
        switch position {
        case .topRight:
            return CGRect(x: self.frame.width - (self.safeAreaInsets.right + width + padding),
                          y: self.safeAreaInsets.top + padding,
                          width: width, height: height)
        default:
            return CGRect(x: 0, y: 0, width: width, height: height)
            
        }
    }
}
