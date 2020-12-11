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
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    
        return cell
    }

    // MARK: UICollectionViewDelegate


}



// MARK: Configures
extension ChatController {
    func configureUI() {
        
    }
    
    func configureNav() {
        title = self.partnerName
    }
}
