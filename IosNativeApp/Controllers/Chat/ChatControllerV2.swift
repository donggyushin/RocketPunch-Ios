//
//  ChatControllerV2.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import UIKit

private let myMessageIdentifier = "myMessageIdentifier"
private let otherMessageIdentifier = "otherMessageIdentifier"

class ChatControllerV2: UIViewController  {
    
    // MARK: Properties
    let roomId:String
    let partnerName:String
    
    private lazy var chatSocket:ChatSocketIOService = {
        let socket = ChatSocketIOService()
        socket.delegate = self
        return socket
    }()
    
    var users:[UserModel] = [] {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
    
    var cursors:[CursorModel] = [] {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
    
    var messages:[MessageModel] = [] {
        didSet {
            
            self.collectionView.reloadData()
            let lastIndex = messages.count - 1
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
            }
            
        }
    }
    
    
    private lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var chatInputView:ChatTextInput = {
        let iv = ChatTextInput()
        iv.delegate = self
        return iv
    }()

    // MARK: Lifecylces
    init(roomId:String, partnerName:String) {
        self.roomId = roomId
        self.partnerName = partnerName
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        configureKeyboard()
        configureCollectionView()
        configureNav()
        connectSocket()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disconnectSocket()
    }
    
    // MARK: Configures
    
    
    func configureUI(){
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        
        
        view.addSubview(chatInputView)
        chatInputView.translatesAutoresizingMaskIntoConstraints = false 
        chatInputView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatInputView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor).isActive = true
        
        
    }
    
    func configureCollectionView() {
        collectionView.register(MyMessageCell.self, forCellWithReuseIdentifier: myMessageIdentifier)
        collectionView.register(OtherMessageCell.self, forCellWithReuseIdentifier: otherMessageIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func configureKeyboard() {
        dismissKeyboardByTouchingAnywhere()
        moveViewWhenKeyboardAppearedV2()
    }
    
    func configureNav() {
        title = self.partnerName
    }
    

}


extension ChatControllerV2:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.messages[indexPath.row].user.id != RootConstants.shared.rootController.user?.id {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherMessageIdentifier, for: indexPath) as! OtherMessageCell
            let message = self.messages[indexPath.row]
            cell.message = message
            
            
            if self.messages.count - 1 != indexPath.row {
                // 이 cell 이 마지막 셀이 아닐때에, 이 셀의 다음 셀이 동일한 유저의 셀이라면,
                // 프로필 이미지를 숨겨주자
                let nextMessage = self.messages[indexPath.row + 1]
                if nextMessage.user.id == message.user.id {
                    cell.profileImageView.isHidden = true
                }else {
                    cell.profileImageView.isHidden = false 
                }
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myMessageIdentifier, for: indexPath) as! MyMessageCell
        cell.message = self.messages[indexPath.row]
        return cell
    }
    
    
}


extension ChatControllerV2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.messages[indexPath.row].user.id != RootConstants.shared.rootController.user?.id {
            
            let stringHeight = self.messages[indexPath.row].text.height(withConstrainedWidth: self.view.frame.width * 0.7 - 18, font: UIFont.systemFont(ofSize: 16))
            
            
            
            return CGSize(width: self.view.frame.width, height: stringHeight + 18)
        }
        
        let stringHeight = self.messages[indexPath.row].text.height(withConstrainedWidth: self.view.frame.width * 0.7 - 18, font: UIFont.systemFont(ofSize: 16))
        
        return CGSize(width: self.view.frame.width, height: stringHeight + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension ChatControllerV2 {
    
    func moveViewWhenKeyboardAppearedV2() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowV2), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideV2), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShowV2(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        self.collectionView.contentInset = UIEdgeInsets(top: keyboardSize.height, left: 0, bottom: 20, right: 0)
      self.view.frame.origin.y = 0 - keyboardSize.height + 20
    }
    
    @objc func keyboardWillHideV2(notification: NSNotification) {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
      self.view.frame.origin.y = 0
    }
}

// MARK: Socket
extension ChatControllerV2 {
    func connectSocket() {
        chatSocket.establishConnection()
    }
    
    func disconnectSocket() {
        chatSocket.closeConnection()
    }
    
    func joinRoom(roomId:String) {
        guard let userId = RootConstants.shared.rootController.user?.id else { return }
        chatSocket.joinRoom(roomId: roomId, userId: userId)
    }
}

extension ChatControllerV2:ChatSocketIOServiceProtocol {
    func newMessage(message: MessageModel) {
        self.messages.append(message)
    }
    
    func initUsers(users: [UserModel]) {
        self.users = users
    }
    
    func initCursors(cursors: [CursorModel]) {
        self.cursors = cursors
    }
    
    func connected() {
        self.joinRoom(roomId: self.roomId)
    }
    
    func errorMessage(message: String) {
        let action = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        
        self.renderAlertTypeTwo(title: nil, message: message, action: action, completion: nil)
    }
    
    func initMessages(messages: [MessageModel]) {
        self.messages = messages
    }
    
    
}


extension ChatControllerV2:ChatTextInputProtocol {
    func sendButtonTapped(text: String) {
        chatSocket.sendMessage(roomId: self.roomId, text: text)
    }
}
