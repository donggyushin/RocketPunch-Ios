//
//  UnreadBadgeView.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/14.
//

import UIKit

class UnreadBadgeView: UIView {
    
    // MARK: Properties
    lazy var numberLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

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
        backgroundColor = .systemBlue
        layer.cornerRadius = 6
        
        addView(view: numberLabel, left: 4, top: 4, right: 4, bottom: 4, width: nil, height: nil, centerX: false, centerY: false)
    }

}
