//
//  UploadProfileImageView.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import UIKit

protocol UploadProfileImageViewProtocol:class {
    func uploadProfileImageView(sender:UploadProfileImageView)
}

class UploadProfileImageView: UIView {

    // MARK: Properties
    weak var delegate:UploadProfileImageViewProtocol?
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - Lifecycles
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

// MARK: - Configures
extension UploadProfileImageView {
    func configureUI() {
        clipsToBounds = true 
        backgroundColor = .secondarySystemBackground
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true 
    }
}


// MARK: - Overrides
extension UploadProfileImageView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.6
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
        self.delegate?.uploadProfileImageView(sender: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
        
    }
}
