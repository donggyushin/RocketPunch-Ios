//
//  UserProfileImageView.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/11.
//

import UIKit

class UserProfileImageView: UIView {
    
    // MARK: Properties
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // MARK: Lifecylces
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configures
    func configureUI () {
        addView(view: imageView, left: 0, top: 0, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
    }
}
