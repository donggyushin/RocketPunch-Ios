//
//  UnreadMessageLabel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/14.
//

import UIKit

class UnreadMessageLabel: UILabel {

    // MARK: Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Configures
    func configureUI() {
        textColor = .systemBlue
        font = UIFont.systemFont(ofSize: 13)
    }

}
