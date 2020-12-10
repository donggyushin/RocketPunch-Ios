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
            self.collectionView.reloadData()
        }
    }
    
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

        // Do any additional setup after loading the view.
        configureUI()
        configureNav()
        fetchUserList()
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.userList.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCellTypeOne
    
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
        clearNavigationBackground()
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

// MARK: Selectors
extension UsersController {
    @objc func logoutButtonTapped(sender:UIButton) {
        RootConstants.shared.rootController.logoutUser()
    }
}


// MARK: - CollectionViewFlowLayout Delegates
extension UsersController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


// MARK: - Properties
extension UsersController {
    
}


extension UsersController:UserCellTypeOneProtocol {
    func userCellTypeOne(sender: UserCellTypeOne) {
        print("user cell tapped")
    }
}
