//
//  UIView+CustomAppearanceExtensions.swift
//  AudioMixingExperiment
//
//  Created by Mikhail Bhuta on 2/29/20.
//  Copyright © 2020 Dirtcube Interactive. All rights reserved.
//

import UIKit

// Rounded corners functionality
extension UIView {
    
    /*
     * Round the corners of a UI view completely. If a view is squar, it will appear as a circle
     */
    func round() {
        self.round(cornerRadius: min(self.bounds.width, self.bounds.height)/2)
    }
    
    /*
     * Round corners of a UI view by the passed in corner radius
     */
    func round(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    /*
     * Add shadows to views
     */
    func addShadow(shadowRadius: CGFloat = 4,
                   shadowOffsetX: CGFloat = 0,
                   shadowOffsetY: CGFloat = 2,
                   shadowColor: UIColor = UIColor.black,
                   shadowOpacity: Float = 0.35) {
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
    }
    
}
