//
//  MyMessageCell.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import UIKit

class MyMessageCell: UICollectionViewCell {
    
    // MARK: Properties
    
    
    
    var message:MessageModel? {
        didSet {
            guard let message = message else { return }
            self.text.text = message.text
            
            self.timeLabel.text = DateUtil.shared.naturalTimeString(date: message.createdAt)
            
            self.dateLine.dateLabel.text = DateUtil.shared.naturalDateStringTypeTwo(date: message.createdAt)
        }
    }
    
    
    lazy var dateLine:DateLineView = {
        let dv = DateLineView()
        return dv
    }()
    
    lazy var bubble:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8 
        return view
    }()
    
    lazy var text:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var timeLabel:DateLabel = {
        let label = DateLabel()
        return label
    }()
    
    lazy var unreadLabel:UnreadMessageLabel = {
        let label = UnreadMessageLabel()
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
        
        addView(view: dateLine, left: nil, top: 10, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: false)
        
        addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false

        bubble.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bubble.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 0.7).isActive = true
        
        bubble.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
        text.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -10).isActive = true
        text.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true
        text.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: bubble.leftAnchor, constant: -7).isActive = true
        
        
        addSubview(unreadLabel)
        unreadLabel.translatesAutoresizingMaskIntoConstraints = false
        unreadLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor).isActive = true
        unreadLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -4).isActive = true
    }
}
