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
    var profileImage:UIImage? {
        didSet {
            guard let profileImage = profileImage else { return }
            self.uploadProfileImageInput.imageView.image = profileImage
        }
    }
    
    private lazy var imagePicker:ImagePicker = {
        let ip = ImagePicker(presentationController: self, delegate: self)
        return ip
    }()
    
    
    private lazy var uploadProfileImageInput:UploadProfileImageView = {
        let input = UploadProfileImageView()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.heightAnchor.constraint(equalToConstant: 100).isActive = true
        input.widthAnchor.constraint(equalToConstant: 100).isActive = true
        input.layer.cornerRadius = 50
        input.delegate = self
        input.isUserInteractionEnabled = true 
        return input
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
        bt.addTarget(self, action: #selector(signUpButtonTapped), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    private lazy var Stack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userIdTextField, userPwTextField, newAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var loading:LoadingView = {
        let lv = LoadingView()
        return lv
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
        
        
        view.addView(view: Stack, left: 20, top: nil, right: 20, bottom: nil, width: nil, height: nil, centerX: true, centerY: true)
        
        view.addSubview(uploadProfileImageInput)
        uploadProfileImageInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadProfileImageInput.bottomAnchor.constraint(equalTo: Stack.topAnchor, constant: -50).isActive = true
        
        
        view.addView(view: loading, left: 0, top: 0, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
        loading.isHidden = true 
    }
    
    func configureKeyboard() {
        dismissKeyboardByTouchingAnywhere()
        moveViewWhenKeyboardAppeared()
    }

}

// MARK: - Selectors
extension SignUpController {
    @objc func signUpButtonTapped(sender:UIButton) {
        // TODO: - 회원가입 프로세스 진행
        
        guard let id = self.userId else { return self.renderAlertTypeOne(title: nil, message: "아이디를 입력해주세요", action: nil, completion: nil)}
        guard let pw = self.userPw else { return self.renderAlertTypeOne(title: nil, message: "비밀번호를 입력해주세요", action: nil, completion: nil)}
        guard let profile = self.profileImage else { return self.renderAlertTypeOne(title: nil, message: "프로필 사진을 등록해주세요", action: nil, completion: nil)}
        
        self.loading.isHidden = false
        DataService.shared.uploadImage(image: profile) { (error, errorMessage, success, url) in
            
            if let errorMessage = errorMessage {
                return self.renderAlertTypeOne(title: nil, message: errorMessage, action: nil, completion: nil)
            }
            
            if let error = error {
                return self.renderAlertTypeOne(title: nil, message: error.localizedDescription, action: nil, completion: nil)
            }
            
            if success == false  { return }
            guard let profileUrl = url else { return }
            
            UserService.shared.signUp(id: id, pw: pw, profile: profileUrl) { (error, errorMessage, success) in
                
                if let errorMessage = errorMessage {
                    return self.renderAlertTypeOne(title: nil, message: errorMessage, action: nil, completion: nil)
                }
                
                if let error = error {
                    return self.renderAlertTypeOne(title: nil, message: error.localizedDescription, action: nil, completion: nil)
                }
                
                if success == false  { return }
                
                // 회원가입까지 시켜주고, 로그인된 화면으로 넘기자
                UserService.shared.signIn(id: id, pw: pw) { (error, errorString, success, user, token) in
                    
                    self.loading.isHidden = true
                    if let errorMessage = errorMessage {
                        return self.renderAlertTypeOne(title: nil, message: errorMessage, action: nil, completion: nil)
                    }
                    
                    if let error = error {
                        return self.renderAlertTypeOne(title: nil, message: error.localizedDescription, action: nil, completion: nil)
                    }
                    
                    if success == false  { return }
                    
                    guard let user = user else { return }
                    guard let token = token else { return }
                    
                    let rootController = RootConstants.shared.rootController
                    rootController.user = user
                    rootController.loginUser(token: token)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
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

extension SignUpController:ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        self.profileImage = image
    }
}


extension SignUpController:UploadProfileImageViewProtocol {
    func uploadProfileImageView(sender: UploadProfileImageView) {
        self.imagePicker.present(from: sender)
    }
}
