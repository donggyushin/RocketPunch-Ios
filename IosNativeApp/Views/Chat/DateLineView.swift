//
//  DateLineView.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import UIKit

class DateLineView: UIView {

    // MARK: Properties
    lazy var dateLabel: DateLabel = {
        let label = DateLabel()
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
        backgroundColor = .systemBackground
        addView(view: dateLabel, left: nil, top: nil, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: true)
    }

}
