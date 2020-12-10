//
//  UIViewExtenstions.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import UIKit

extension UIView {
    func addView(view:UIView, left:CGFloat?, top:CGFloat?, right:CGFloat?, bottom:CGFloat?, width:CGFloat?, height:CGFloat?, centerX:Bool, centerY:Bool) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
        }
        
        if let right = right {
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -right).isActive = true
        }
        
        if let top = top {
            view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        }
        
        if let bottom = bottom {
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
        }
        
        if let width = width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if centerX {
            view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        if centerY {
            view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true 
        }
    }
}
