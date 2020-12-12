//
//  ChatSocketIOService.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import Foundation
import SocketIO

protocol ChatSocketIOServiceProtocol:class {
    func connected()
    func errorMessage(message:String)
    func initMessages(messages:[MessageModel])
}

class ChatSocketIOService: NSObject {
    
    
    var manager = SocketManager(socketURL: URL(string: "http://192.168.0.42:9091")!)
    var socket:SocketIOClient!
    var delegate:ChatSocketIOServiceProtocol?
    
    override init() {
        super.init()
        
        socket = self.manager.defaultSocket
        
        socket.on("connected") { (dataArray, _) in
            guard let data = dataArray[0] as? [String:Any] else { return }
            guard let ok = data["ok"] as? Bool else { return }
            if ok {
                self.delegate?.connected()
            }
        }
        
        socket.on("initial_messages") { (dataArray, _) in
            guard let data = dataArray[0] as? [String:Any] else { return }
            guard let ok = data["ok"] as? Bool else { return }
            if ok {
                guard let messagesDict = data["messages"] as? [[String:Any]] else { return }
                var messages:[MessageModel] = []
                for messageDict in messagesDict {
                    let message = MessageModel(dict: messageDict)
                    messages.append(message)
                }
                self.delegate?.initMessages(messages: messages)
            }else {
                guard let message = data["message"] as? String else { return }
                self.delegate?.errorMessage(message: message)
            }
        }
        
    }
    
    func establishConnection() { socket.connect() }
    func closeConnection() { socket.disconnect() }
    
    func joinRoom(roomId:String, userId:String) {
        
        self.socket.emit("join", ["roomId":roomId, "userId":userId])
    }

    
}
