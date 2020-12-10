//
//  UsersController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

private let reuseIdentifier = "Cell"

class UsersController: UICollectionViewController {
    
    // MARK: - Properties
    private lazy var logoutButton:UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("로그아웃", for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(logoutButtonTapped), for: UIControl.Event.touchUpInside)
        return bt
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

        // Do any additional setup after loading the view.
        configureUI()
        configureNav()
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


}


// MARK: - Configures
extension UsersController {
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
    }
    
    func configureNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
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
    
}


// MARK: - Properties
extension UsersController {
    
}
