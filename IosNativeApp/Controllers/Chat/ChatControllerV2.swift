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
            
            // 새로운 메시지가 들어올때마다 가장 마지막 메시지를 읽는다.
            if let me = RootConstants.shared.rootController.user {
                let lastMessage = self.messages[lastIndex]
                self.chatSocket.readMessage(roomId: self.roomId, userId: me.id, messageId: String(lastMessage.messageId))
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
        
        
        // 다른 사람이 보낸 메시지 일때
        if self.messages[indexPath.row].user.id != RootConstants.shared.rootController.user?.id {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherMessageIdentifier, for: indexPath) as! OtherMessageCell
            cell.dateLine.isHidden = true
            
            // 읽음 처리
            var totalNumber = self.users.count
            for cursor in self.cursors {
                if cursor.recentReadMessageId >= self.messages[indexPath.row].messageId {
                    totalNumber = totalNumber - 1
                }
            }
            
            if totalNumber == 0 {
                cell.unreadLabel.text = ""
            }else {
                cell.unreadLabel.text = "\(totalNumber)"
            }
            // 첫 메시지 이면 날짜 구분선이 붙은 메시지 셀을 반환해준다.
            if indexPath.row == 0 {
                cell.dateLine.isHidden = false
            }else {
                // 첫번째 메시지가 아닌데, 이전과 날짜가 서로 다를 경우에는 날짜구분선 렌더링
                let currentMessage = self.messages[indexPath.row]
                let prevMessage = self.messages[indexPath.row - 1]
                
                if !DateUtil.shared.compareTwoDate(date1: currentMessage.createdAt, date2: prevMessage.createdAt) {
                    cell.dateLine.isHidden = false
                }
            }
            
            
            let message = self.messages[indexPath.row]
            cell.message = message
            cell.profileImageView.isHidden = false

            
            if self.messages.count - 1 != indexPath.row {
                
                let nextMessage = self.messages[indexPath.row + 1]
                if nextMessage.user.id == message.user.id {
                    // 이 cell 이 마지막 셀이 아닐때에, 이 셀의 다음 셀이 동일한 유저의 셀이라면,
                    // 프로필 이미지를 숨겨주자
                    cell.profileImageView.isHidden = true
                    
                    // 다음셀과 시간이 같다면 타임라벨을 숨겨주자
                    let currentMessageTimeString = DateUtil.shared.naturalTimeString(date: message.createdAt)
                    let nextMessageTimeString = DateUtil.shared.naturalTimeString(date: nextMessage.createdAt)
                    if currentMessageTimeString == nextMessageTimeString {

                        cell.timeLabel.text = ""
                    }
                }else {
                    cell.profileImageView.isHidden = false
                }
                return cell
            }
            // 만약 마지막 메시지이다
            // 사진이랑 시간 둘다 렌더링
            cell.profileImageView.isHidden = false
            return cell
        }
        
        // 내가 보낸 메시지일때
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myMessageIdentifier, for: indexPath) as! MyMessageCell
        cell.message = self.messages[indexPath.row]
        
        // 읽음 처리하자
        var totalNumber = self.users.count
        for cursor in self.cursors {
            if cursor.recentReadMessageId >= cell.message!.messageId {
                totalNumber = totalNumber - 1
            }
        }
        
        if totalNumber <= 0 {
            cell.unreadLabel.text = ""
        }else {
            cell.unreadLabel.text = "\(totalNumber)"
        }
        
        cell.dateLine.isHidden = true
        
        
        // 만약에 첫번째 메시지라면 dateLine을 렌더링,
        if indexPath.row == 0 {
            cell.dateLine.isHidden = false 
        }else {
            // 첫번째 메시지가 아닌데, 이전 메시지랑 날짜가 다를경우 dateLine을 렌더링
            let curremtMessage = self.messages[indexPath.row]
            let prevMessage = self.messages[indexPath.row - 1]
            
            if !DateUtil.shared.compareTwoDate(date1: curremtMessage.createdAt, date2: prevMessage.createdAt) {
                cell.dateLine.isHidden = false
            }
            
        }
        
        
        // 이게 마지막 메시지라면 그대로 메시지 렌더링
        if messages.count - 1 == indexPath.row {
            return cell
        }
        
        // 다음 메시지도 나의 메시지라면,
        let currentMessage = self.messages[indexPath.row]
        let nextMessage = self.messages[indexPath.row + 1]
        
        if currentMessage.user.id == nextMessage.user.id {
            // 다음 메시지 셀과, 현재 메시지 셀의 시간이 서로 같다면,
            let currentMessageTimeLabel = DateUtil.shared.naturalTimeString(date: currentMessage.createdAt)
            let nextMessageTimeLabel = DateUtil.shared.naturalTimeString(date: nextMessage.createdAt)
            
            if currentMessageTimeLabel == nextMessageTimeLabel {
                // 현재 메시지 셀의 시간은 지워준다.
                cell.timeLabel.text = ""
            }
        }
        
        return cell
    }
    
    
}


extension ChatControllerV2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let stringHeight = self.messages[indexPath.row].text.height(withConstrainedWidth: self.view.frame.width * 0.7 - 18, font: UIFont.systemFont(ofSize: 16))
        
        
        if indexPath.row == 0 {
            // 첫번째 메시지일 경우
            // 날짜선을 표기해주어야 하기 때문에, 높이를 30정도 더 준다
            return CGSize(width: self.view.frame.width, height: stringHeight + 48)
        }
        
        
        let currentMessage = self.messages[indexPath.row]
        let prevMessage = self.messages[indexPath.row - 1]
        
        if !DateUtil.shared.compareTwoDate(date1: currentMessage.createdAt, date2: prevMessage.createdAt) {
            // 이전 메시지와 날짜가 다를 경우
            // 날짜선을 표기해주어야 하기 때문에, 높이를 30정도 더 준다
            return CGSize(width: self.view.frame.width, height: stringHeight + 48)
        }
        
        
        
        // 상대편 메시지일때
        if self.messages[indexPath.row].user.id != RootConstants.shared.rootController.user?.id {
            
            
            
            return CGSize(width: self.view.frame.width, height: stringHeight + 18)
        }
        
        // 내 메시지일때
        
        
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
    func cursorUpdated(cursors: [CursorModel]) {
        self.cursors = cursors
    }
    
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
