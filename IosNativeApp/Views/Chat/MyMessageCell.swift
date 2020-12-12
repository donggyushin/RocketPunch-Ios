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
        }
    }
    
    private lazy var bubble:UIView = {
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
        
        addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubble.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 0.7).isActive = true
        
        bubble.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
        text.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -10).isActive = true
        text.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true
        text.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
    }
}
