//
//  SignUpController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

class SignUpController: UIViewController {

    // MARK: - Properties
    var userId:String?
    var userPw:String?
    
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        return label
    }()
    
    private lazy var userIdTextField:TextInputTypeOne = {
        let tf = TextInputTypeOne()
        tf.textField.placeholder = "아이디를 입력해주세요"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.delegate = self
        return tf
    }()
    
    private lazy var userPwTextField:TextInputTypeOne = {
        let tf = TextInputTypeOne()
        tf.textField.isSecureTextEntry = true
        tf.textField.placeholder = "비밀번호를 입력해주세요"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.delegate = self
        return tf
    }()
    
    private lazy var newAccountButton:UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("회원가입", for: UIControl.State.normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private lazy var Stack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userIdTextField, userPwTextField, newAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureKeyboard()
    }
    

}


// MARK: - Configures
extension SignUpController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(Stack)
        Stack.translatesAutoresizingMaskIntoConstraints = false
        Stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        Stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        Stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        Stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureKeyboard() {
        dismissKeyboardByTouchingAnywhere()
        moveViewWhenKeyboardAppeared()
    }
}




extension SignUpController:TextInputTypeOneDelegate {
    func textInputTypeOne(textInput: TextInputTypeOne, text: String) {
        if textInput == userIdTextField {
            self.userId = text
        }
        
        if textInput == userPwTextField {
            self.userPw = text
        }
    }
}
