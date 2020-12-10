//
//  LoadingView.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: Properties
    private lazy var indicator:UIActivityIndicatorView = {
        let id = UIActivityIndicatorView()
        return id
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
        
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.startAnimating()
    }
    
}
