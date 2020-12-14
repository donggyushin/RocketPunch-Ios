//
//  OtherMessageCell.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import UIKit
import SDWebImage

class OtherMessageCell: UICollectionViewCell {
    // MARK: Properties
    
    var message:MessageModel? {
        didSet {
            guard let message = message else { return }
            if let url = URL(string: message.user.profile) {
                self.profileImageView.sd_setImage(with: url, completed: nil)
            }
            
            self.text.text = message.text
            
            
            self.timeLabel.text = DateUtil.shared.naturalTimeString(date: message.createdAt)
            
            self.dateLine.dateLabel.text = DateUtil.shared.naturalDateStringTypeTwo(date: message.createdAt)
            
        }
    }
    
    
    lazy var dateLine:DateLineView = {
        let dv = DateLineView()
        return dv
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    lazy var text:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.dataDetectorTypes = .link
        tv.isSelectable = true
        tv.backgroundColor = .secondarySystemBackground
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.sizeToFit()
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
    func configureUI(){
        
        backgroundColor = .systemBackground
        
        addView(view: dateLine, left: nil, top: 50, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: false)
        
        
        addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 62).isActive = true 
        text.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 0.7).isActive = true
        
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 0).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: text.rightAnchor, constant: 7).isActive = true
        
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: text.topAnchor, constant: -10).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        
        addSubview(unreadLabel)
        unreadLabel.translatesAutoresizingMaskIntoConstraints = false
        unreadLabel.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        unreadLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 4).isActive = true
        
    }
}
