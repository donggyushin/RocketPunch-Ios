//
//  ChatRoomCell.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import UIKit
import SDWebImage

protocol ChatRoomCellProtocol:class {
    func chatRoomCell(sender:ChatRoomCell)
}

class ChatRoomCell: UICollectionViewCell {
    // MARK: Properties
    weak var delegate:ChatRoomCellProtocol?
    
    var chatRoom:ChatRoomModel? {
        didSet {
            guard let chatRoom = self.chatRoom else { return }
            // 내가 아닌 상대방 유저를 찾아내야함.
            guard let me = RootConstants.shared.rootController.user else { return }
            configureChatRoom(chatRoom: chatRoom, me: me)
        }
    }
    
    private lazy var profileImageView:UserProfileImageView = {
        let iv = UserProfileImageView()
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv 
    }()
    
    var partner:UserModel?
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var recentMessage:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var dayString:DateLabel = {
        let label = DateLabel()
        return label
    }()
    
    private lazy var divider:UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    // MARK: Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configures
    func configureUI() {
        backgroundColor = .systemBackground
        
        addView(view: profileImageView, left: 20, top: 20, right: nil, bottom: nil, width: nil, height: nil, centerX: false, centerY: false)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        
        addSubview(recentMessage)
        recentMessage.translatesAutoresizingMaskIntoConstraints = false
        recentMessage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        recentMessage.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        addView(view: dayString, left: nil, top: nil, right: 20, bottom: nil, width: nil, height: nil, centerX: false, centerY: false)
        dayString.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true 
        
        addView(view: divider, left: nil, top: nil, right: 0, bottom: 0, width: nil, height: nil, centerX: false, centerY: false)
        divider.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true 
        
    }
    
    func configureChatRoom(chatRoom:ChatRoomModel, me:UserModel) {
        let partners = chatRoom.users.filter { (user) -> Bool in
            return me.id != user.id
        }
        let partner = partners[0]
        
        self.partner = partner
        
        if let url = URL(string: partner.profile) {
            self.profileImageView.imageView.sd_setImage(with: url, completed: nil)
        }
        
        self.nameLabel.text = partner.id
        
        if chatRoom.messages.count == 0 {
            self.recentMessage.text = "\(partner.id) 님과 채팅을 시작해보세요!"
        }else {
            let message = chatRoom.messages[chatRoom.messages.count - 1]
            self.recentMessage.text = message.text
        }
        
        self.dayString.text = DateUtil.shared.naturalDateString(date: chatRoom.updatedAt)
    }
    
    // MARK: Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.6
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
        self.delegate?.chatRoomCell(sender: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1
    }
}
