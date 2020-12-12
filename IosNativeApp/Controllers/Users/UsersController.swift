//
//  UsersController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

private let reuseIdentifier = "UserCellTypeOne"

class UsersController: UICollectionViewController {
    
    // MARK: - Properties
    
    
    var userList:[UserModel] = [] {
        didSet {
            
            self.filteredUserList = userList
        }
    }
    
    var filteredUserList:[UserModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "유저"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var logoutButton:UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("로그아웃", for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(logoutButtonTapped), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    
    private lazy var loadingView:LoadingView = {
        let lv = LoadingView()
        return lv
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
        self.collectionView!.register(UserCellTypeOne.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true

        // Do any additional setup after loading the view.
        configureUI()
        configureNav()
        fetchUserList()
        configureSearchController()
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.filteredUserList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCellTypeOne
        cell.user = self.filteredUserList[indexPath.row]
        // Configure the cell
        cell.delegate = self
        
    
        return cell
    }


}


// MARK: - Configures
extension UsersController {
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        
        view.addView(view: loadingView, left: 0, top: 0, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
    }
    
    func configureNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.backButtonTitle = "이전"
        clearNavigationBackground()
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "유저를 검색하세요!"
        
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: APIs
extension UsersController {
    func fetchUserList() {
        UserService.shared.fetchUserList { (error, errorMessage, success, userList) in
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
            
            self.userList = userList
            
        }
    }
}

// MARK: Helpers
extension UsersController {
    func filterContentForSearchText(searchText:String, category:[UserModel]) -> [UserModel] {
        var filteredCategory:[UserModel] = []
        filteredCategory = category.filter({ (user) -> Bool in
            return user.id.lowercased().contains(searchText.lowercased())
        })
        return filteredCategory
    }
    
    func navigateToChatController(user:UserModel) {
        
        guard let me = RootConstants.shared.rootController.user else { return }
        
        if user.id == me.id {
            return self.renderAlertTypeOne(title: nil, message: "본인과는 채팅할 수 없습니다", action: nil, completion: nil)
        }
        
        self.loadingView.isHidden = false
        let userIds:[String] = [me.id, user.id]
        
        ChatService.shared.fetchRoomId(userIds: userIds) { (error, errorString, success, roomId) in
            self.loadingView.isHidden = true 
            if let errorMessage = errorString {
                return self.renderAlertTypeOne(title: nil, message: errorMessage, action: nil, completion: nil)
            }
            
            if let error = error {
                return self.renderAlertTypeOne(title: nil, message: error.localizedDescription, action: nil, completion: nil)
            }
            
            if success == false {
                return self.renderAlertTypeOne(title: nil, message: "알 수 없는 에러 발생", action: nil, completion: nil)
            }
            
            guard let roomId = roomId else { return }
//            let chatController = ChatController(roomId: roomId, partnerName: user.id)
            let chatController = ChatControllerV2(roomId: roomId, partnerName: user.id)
            self.navigationController?.pushViewController(chatController, animated: true)
            
        }
        
    }
}

// MARK: Selectors
extension UsersController {
    @objc func logoutButtonTapped(sender:UIButton) {
        RootConstants.shared.rootController.logoutUser()
    }
}


// MARK: - CollectionViewFlowLayout Delegates
extension UsersController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}


// MARK: - Properties
extension UsersController {
    
}


extension UsersController:UserCellTypeOneProtocol {
    func userCellTypeOne(sender: UserCellTypeOne) {
        
        guard let user = sender.user else { return }
        
        let action = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.navigateToChatController(user: user)
        }
        self.renderAlertTypeTwo(title: nil, message: "\(user.id)와 채팅을 시작하시겠습니까?", action: action, completion: nil)
    }
}


extension UsersController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    if text.isEmpty {
        return self.filteredUserList = self.userList
    }
    return self.filteredUserList = filterContentForSearchText(searchText: text, category: self.userList)
  }
}
