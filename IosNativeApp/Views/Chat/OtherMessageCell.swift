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
    
    private lazy var bubble:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var text:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeLabel:DateLabel = {
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
    func configureUI(){
        
        backgroundColor = .systemBackground
        
        addView(view: dateLine, left: nil, top: 10, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: false)
        
        addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bubble.leftAnchor.constraint(equalTo: leftAnchor, constant: 62).isActive = true
        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 0.7).isActive = true
        
        addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
        text.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 10).isActive = true
        text.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -8).isActive = true
        text.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: 0).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: bubble.rightAnchor, constant: 7).isActive = true
        
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: bubble.topAnchor, constant: -10).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        
    }
}
