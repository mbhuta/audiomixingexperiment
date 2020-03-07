//
//  UIView+SafeAreaExtensions.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

extension UIView {
    
    func getSafeAreaRect() -> CGRect {
        let height: CGFloat = self.frame.height - (self.safeAreaInsets.top + self.safeAreaInsets.bottom)
        let width: CGFloat = self.frame.width - (self.safeAreaInsets.left + self.safeAreaInsets.right)
        let x: CGFloat = self.safeAreaInsets.left
        let y: CGFloat = self.safeAreaInsets.top
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
