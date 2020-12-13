//
//  DateLabel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import UIKit

class DateLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont.systemFont(ofSize: 13)
        textColor = .placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
