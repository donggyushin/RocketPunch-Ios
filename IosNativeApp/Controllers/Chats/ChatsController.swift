//
//  ChatsController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

private let reuseIdentifier = "chatRoomCell"

class ChatsController: UICollectionViewController {
    
    // MARK: Properties
    var chatRooms:[ChatRoomModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var chatsSocket:ChatsSocketIOService = {
        let sc = ChatsSocketIOService()
        sc.delegate = self 
        return sc
    }()

    // MARK: - Lifecycles
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Register cell classes
        self.collectionView!.register(ChatRoomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureNav()
        connectSocket()
        configureCollectionview()
    }
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.chatRooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatRoomCell
    
        // Configure the cell
        cell.chatRoom = self.chatRooms[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegate

   

}


// MARK: Configures
extension ChatsController {
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
    }
    
    func configureNav() {
        clearNavigationBackground()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonTitle = "채팅"
    }
    
    func configureCollectionview() {
        collectionView.alwaysBounceVertical = true
    }
}


// MARK: Socket
extension ChatsController {
    func connectSocket() {
        self.chatsSocket.establishConnection()
    }
    
    func disconnectSocket() {
        self.chatsSocket.closeConnection()
    }
}


extension ChatsController:ChatsSocketIOServiceProtocol {
    func chatRooms(chatRooms: [ChatRoomModel]) {
        self.chatRooms = chatRooms
    }
    
    func errorMessage(message: String) {
        self.renderAlertTypeOne(title: nil, message: message, action: nil, completion: nil)
    }
    
    func connected() {
        guard let userId = RootConstants.shared.rootController.user?.id else { return }
        
        self.chatsSocket.joinRoomList(userId: userId)
    }
}


extension ChatsController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


extension ChatsController:ChatRoomCellProtocol {
    func chatRoomCell(sender: ChatRoomCell) {
        guard let roomId = sender.chatRoom?.id else { return }
        guard let partner = sender.partner else { return }
        let chatController = ChatControllerV2(roomId: roomId, partnerName: partner.id)
        navigationController?.pushViewController(chatController, animated: true)
    }
}
