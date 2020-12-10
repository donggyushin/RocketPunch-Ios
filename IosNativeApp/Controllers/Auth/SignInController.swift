//
//  SignInController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

class SignInController: UIViewController {
    
    // MARK: - Properties
    var userId:String?
    var userPw:String?
    
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "로켓채팅"
        label.font = UIFont.systemFont(ofSize: 20)
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
    
    private lazy var loginButton:UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("로그인", for: UIControl.State.normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bt.addTarget(self, action: #selector(signInButtonTapped), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    private lazy var Stack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userIdTextField, userPwTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var signUpControllerButton:UIButton = {
        

        let secondAttributes:[NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]

        let firstString = NSMutableAttributedString(string: "아직 계정이 없으신가요? ")
        let secondString = NSAttributedString(string: "회원가입", attributes: secondAttributes)
        

        firstString.append(secondString)
        
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setAttributedTitle(firstString, for: UIControl.State.normal)
        
        bt.addTarget(self, action: #selector(signUpButtonTapped), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    private lazy var loadingView:LoadingView = {
        let lv = LoadingView()
        return lv
    }()

    // MARK: - Lifecylces
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNav()
        configureKeyboard()
    }
    
}

// MARK: Selectors
extension SignInController {
    
    @objc func signUpButtonTapped() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func signInButtonTapped(sender:UIButton) {
        guard let id = self.userId else { return self.renderAlertTypeOne(title: nil, message: "아이디를 입력해주세요", action: nil, completion: nil)}
        guard let pw = self.userPw else { return self.renderAlertTypeOne(title: nil, message: "비밀번호를 입력해주세요", action: nil, completion: nil)}
        
        loadingView.isHidden = false
        
        UserService.shared.signIn(id: id, pw: pw) { (error, errorMessage, success, user, token) in
            self.loadingView.isHidden = true
            if let errorMessage = errorMessage {
                return self.renderAlertTypeOne(title: nil, message: errorMessage, action: nil, completion: nil)
            }
            
            if let error = error {
                return self.renderAlertTypeOne(title: nil, message: error.localizedDescription, action: nil, completion: nil)
            }
            
            if success == false {
                return self.renderAlertTypeOne(title: nil, message: "알 수 없는 에러 발생", action: nil, completion: nil)
            }
            
            guard let user = user else { return }
            guard let token = token else { return }
            
            let rootController = RootConstants.shared.rootController
            rootController.user = user
            rootController.loginUser(token: token)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}

// MARK: - Configures
extension SignInController {
    func configureUI(){
        view.backgroundColor = .systemBackground
        
        
        view.addView(view: Stack, left: 20, top: nil, right: 20, bottom: nil, width: nil, height: nil, centerX: true, centerY: true)
        
        view.addSubview(signUpControllerButton)
        signUpControllerButton.translatesAutoresizingMaskIntoConstraints = false
        signUpControllerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signUpControllerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addView(view: loadingView, left: 0, top: 0, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
        loadingView.isHidden = true
        
    }
    
    func configureNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonTitle = "이전"
        clearNavigationBackground()
    }
    
    func configureKeyboard() {
        dismissKeyboardByTouchingAnywhere()
        moveViewWhenKeyboardAppeared()
    }
}

extension SignInController:TextInputTypeOneDelegate {
    func textInputTypeOne(textInput: TextInputTypeOne, text: String) {
        if textInput == userIdTextField {
            self.userId = text
        }
        
        if textInput == userPwTextField {
            self.userPw = text
        }
    }
}
