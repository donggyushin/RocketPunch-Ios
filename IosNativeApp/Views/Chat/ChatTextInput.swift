//
//  ChatTextInput.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import UIKit
import GrowingTextView

protocol ChatTextInputProtocol:class {
    func sendButtonTapped(text:String)
}

class ChatTextInput: UIView, UITextViewDelegate {
    
    // MARK: Properties
    weak var delegate:ChatTextInputProtocol?
    
    
    lazy var messageInputTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.delegate = self
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.maxLength = 400
        tv.maxHeight = 150
        return tv
    }()
    
    private lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("전송", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        button.addTarget(self, action: #selector(sendButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "메시지를 입력해주세요..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.placeholderText
        return label
    }()
    
    private lazy var divider:UIView = {
        let divider = UIView()
        divider.backgroundColor = .secondarySystemFill
        return divider
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
//        autoresizingMask = .flexibleHeight
        backgroundColor = .systemBackground
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.white.cgColor
        
        addSubview(messageInputTextView)
        messageInputTextView.translatesAutoresizingMaskIntoConstraints = false
        messageInputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        messageInputTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -70).isActive = true
        messageInputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        messageInputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        messageInputTextView.addView(view: placeholderLabel, left: 4, top: nil, right: nil, bottom: nil, width: nil, height: nil, centerX: false, centerY: true)

        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: messageInputTextView.topAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: messageInputTextView.rightAnchor, constant: 0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageInputTextView.bottomAnchor).isActive = true
        
        addView(view: divider, left: 0, top: 0, right: 0, bottom: nil, width: nil, height: 1, centerX: false, centerY: false)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
//
//    override var intrinsicContentSize: CGSize {
//        return .zero
//    }
    
    // MARK: Selectors
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func sendButtonTapped(){
        guard let text = self.messageInputTextView.text else { return }
        self.messageInputTextView.text = ""
        self.delegate?.sendButtonTapped(text: text)
    }
    
}
