//
//  TextInputTypeOne.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit


protocol TextInputTypeOneDelegate:class {
    func textInputTypeOne(textInput:TextInputTypeOne, text:String)
}

class TextInputTypeOne: UIView {
    
    // MARK: Properties
    weak var delegate:TextInputTypeOneDelegate?
    private var placeHolder:String?
    
    
    lazy var textField:UITextField = {
        let tf = UITextField()
        tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }()

    // MARK: Lifecylces
    init() {
        
        super.init(frame: CGRect.zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configures
    func configureUI() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 6
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Selectors
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.delegate?.textInputTypeOne(textInput: self, text: text)
    }
}

