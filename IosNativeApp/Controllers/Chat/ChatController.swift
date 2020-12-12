//
//  ChatController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatController: UICollectionViewController {
    // MARK: Properties
    let roomId:String
    let partnerName:String
    
    var messages:[MessageModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    private lazy var chatSocket:ChatSocketIOService = {
        let socket = ChatSocketIOService()
        socket.delegate = self
        return socket
    }()
    
    
    private lazy var loadingView:LoadingView = {
        let lv = LoadingView()
        return lv
    }()
    
    private lazy var chatInputView:ChatTextInput = {
        let iv = ChatTextInput()
        return iv
    }()
    
    

    // MARK: Lifecyles
    init(roomId:String, partnerName:String ) {
        self.roomId = roomId
        self.partnerName = partnerName
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        hidesBottomBarWhenPushed = true 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureNav()
        connectSocket()
        configureKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        collectionView.addGestureRecognizer(tap)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disconnectSocket()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    
        return cell
    }

    // MARK: UICollectionViewDelegate


}



// MARK: Overrides
extension ChatController {
    
    
    override var inputAccessoryView: UIView? {
        get {
            return self.chatInputView
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    
    
}

// MARK: Selectors
extension ChatController {
    @objc func dismissKeyboard() {
        print("1")
        self.chatInputView.messageInputTextView.resignFirstResponder()
    }
}

// MARK: Configures
extension ChatController {
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        
        view.addView(view: loadingView, left: 0, top: 0, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
    }
    
    func configureNav() {
        title = self.partnerName
    }
    
    func configureKeyboard() {
        dismissKeyboardByTouchingAnywhere()
    }
    
}


// MARK: Socket
extension ChatController {
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



extension ChatController:ChatSocketIOServiceProtocol {
    func errorMessage(message: String) {
        
        let action = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        
        self.renderAlertTypeTwo(title: nil, message: message, action: action, completion: nil)
    }
    
    func initMessages(messages: [MessageModel]) {
        self.loadingView.isHidden = true
        self.messages = messages
    }
    
    func connected() {
        
        self.joinRoom(roomId: self.roomId)
    }
}
