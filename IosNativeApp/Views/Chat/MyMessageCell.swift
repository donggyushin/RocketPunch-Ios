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
    
    
    lazy var text:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.isEditable = false
        tv.dataDetectorTypes = .link
        tv.isSelectable = true
        tv.backgroundColor = .systemBlue
        tv.tintColor = .systemPurple
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        tv.isScrollEnabled = false
        let fixedWidth = self.frame.width * 0.7
        let newSize = tv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        tv.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return tv
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
        
        addView(view: dateLine, left: nil, top: 50, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: false)
        
        
        addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 0.7).isActive = true
        
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: text.leftAnchor, constant: -7).isActive = true
        
        
        addSubview(unreadLabel)
        unreadLabel.translatesAutoresizingMaskIntoConstraints = false
        unreadLabel.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        unreadLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -4).isActive = true
    }
}
