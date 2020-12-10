//
//  UserCellTypeOne.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/11.
//

import UIKit

protocol UserCellTypeOneProtocol:class {
    func userCellTypeOne(sender:UserCellTypeOne)
}

class UserCellTypeOne: UICollectionViewCell {
    
    // MARK: Properties
    weak var delegate: UserCellTypeOneProtocol?
    private lazy var test:UILabel = {
        let label = UILabel()
        label.text = "test"
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
        
        addView(view: test, left: nil, top: nil, right: nil, bottom: nil, width: nil, height: nil, centerX: true, centerY: true)
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
