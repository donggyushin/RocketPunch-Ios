//
//  UserCellTypeOne.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/11.
//

import UIKit
import SDWebImage

protocol UserCellTypeOneProtocol:class {
    func userCellTypeOne(sender:UserCellTypeOne)
}

class UserCellTypeOne: UICollectionViewCell {
    
    // MARK: Properties
    weak var delegate: UserCellTypeOneProtocol?
    var user:UserModel? {
        didSet {
            guard let user = self.user else { return }
            self.name.text = user.id
            if let url = URL(string: user.profile) {
                self.userProfileImageView.imageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    private lazy var userProfileImageView:UserProfileImageView = {
        let iv = UserProfileImageView()
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private lazy var name:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var stack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userProfileImageView, name])
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
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
        
        addView(view: stack, left: 20, top: nil, right: nil, bottom: nil, width: nil, height: nil, centerX: false, centerY: true)
    }
    
    // MARK: Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.6
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
        
        self.delegate?.userCellTypeOne(sender: self)
    }
}
