//
//  ChatsController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatsController: UICollectionViewController {
    
    // MARK: Properties
    var chatRooms:[ChatRoomModel] = [] {
        didSet {
            print("chat rooms 받음: \(chatRooms)")
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
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureNav()
        connectSocket()
        
    }
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
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
        print("connected with socket")
        guard let userId = RootConstants.shared.rootController.user?.id else { return }
        
        self.chatsSocket.joinRoomList(userId: userId)
    }
}
