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
    func initUsers(users:[UserModel])
    func initCursors(cursors:[CursorModel])
    func newMessage(message:MessageModel)
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
        
        socket.on("room_loaded") { (dataArray, _) in
            guard let data = dataArray[0] as? [String:Any] else { return }
            guard let ok = data["ok"] as? Bool else { return }
            if !ok {
                guard let message = data["message"] as? String else { return }
                self.delegate?.errorMessage(message: message)
            }else {
                guard let messagesDict = data["messages"] as? [[String:Any]] else { return }
                var messages:[MessageModel] = []
                for messageDict in messagesDict {
                    let message = MessageModel(dict: messageDict)
                    messages.append(message)
                }
                self.delegate?.initMessages(messages: messages)
                
                guard let usersDict = data["users"] as? [[String:Any]] else { return }
                var users:[UserModel] = []
                for userDict in usersDict {
                    let user = UserModel(dict: userDict)
                    users.append(user)
                }
                
                self.delegate?.initUsers(users: users)
                
                guard let cursorsDict = data["cursors"] as? [[String:Any]] else { return }
                var cursors:[CursorModel] = []
                for cursorDict in cursorsDict {
                    let cursor = CursorModel(dict: cursorDict)
                    cursors.append(cursor)
                }
                
                self.delegate?.initCursors(cursors: cursors)
                
                
            }
        }
        
        socket.on("new_message") { (dataArray, _) in
            guard let data = dataArray[0] as? [String:Any] else { return }
            print("received new data: \(data)")
            guard let ok = data["ok"] as? Bool else { return }
            if !ok {
                guard let errorMessage = data["message"] as? String else { return }
                self.delegate?.errorMessage(message: errorMessage)
            }else {
                guard let messageDict = data["message"] as? [String:Any] else { return }
                let message = MessageModel(dict: messageDict)
                self.delegate?.newMessage(message: message)
            }
        }
        
    }
    
    func establishConnection() { socket.connect() }
    func closeConnection() { socket.disconnect() }
    
    func joinRoom(roomId:String, userId:String) {
        
        self.socket.emit("join", ["roomId":roomId, "userId":userId])
    }
    
    func sendMessage(roomId:String, text:String) {
        guard let token = DeviceDataService.shared.gettingDeviceData(key: AuthConstants.AUTH_TOKEN) else { return }
        self.socket.emit("new_message", ["roomId":roomId, "userToken": token, "text": text])
    }

    
}
