//
//  ChatsSocketIOService.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import Foundation
import SocketIO

protocol ChatsSocketIOServiceProtocol:class {
    func connected()
    func errorMessage(message:String)
    func chatRooms(chatRooms:[ChatRoomModel])
}

class ChatsSocketIOService:NSObject {
    
    weak var delegate:ChatsSocketIOServiceProtocol?
    
    var manager = SocketManager(socketURL: URL(string: EndpointConstants.shared.ROCKET_PUNCH_SOCKET)!)
    var socket:SocketIOClient!
    
    override init() {
        super.init()
        
        socket = self.manager.socket(forNamespace: "/roomlist")
        
        socket.on("connected") { (dataArray, _) in
            guard let data = dataArray[0] as? [String:Any] else { return }
            guard let ok = data["ok"] as? Bool else { return }
            if ok {
                self.delegate?.connected()
            }
        }
        
        socket.on("room_list") { (dataArray, _) in
            
            guard let data = dataArray[0] as? [String:Any] else { return }
            guard let ok = data["ok"] as? Bool else { return }
            if !ok {
                guard let message = data["message"] as? String else { return }
                self.delegate?.errorMessage(message: message)
            }else {
                guard let chatsDict = data["chats"] as? [[String:Any]] else { return }
                var chatRooms:[ChatRoomModel] = []
                for chatDict in chatsDict {
                    let chatRoom = ChatRoomModel(dict: chatDict)
                    chatRooms.append(chatRoom)
                }
                self.delegate?.chatRooms(chatRooms: chatRooms)
            }
        }
    }
    
    func establishConnection() { socket.connect() }
    func closeConnection() { socket.disconnect() }
    
    func joinRoomList(userId:String) {
        socket.emit("join_room_list", ["userId":userId])
    }
}
