//
//  UIViewExtension.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 12/12/20.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, height: CGFloat, width: CGFloat, centerX: NSLayoutXAxisAnchor?, centerY:NSLayoutYAxisAnchor?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if height != CGFloat.zero {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != CGFloat.zero {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
