//
//  ChatRoomModel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import Foundation


struct ChatRoomModel {
    var users:[UserModel]
    var messages:[MessageModel]
    var cursors:[CursorModel]
    var updatedAt:Date
    var id:String
    
    init(dict:[String:Any]) {
        let usersDict = dict["users"] as! [[String:Any]]
        let messagesDict = dict["messages"] as! [[String:Any]]
        let cursorsDict = dict["cursors"] as! [[String:Any]]
        let id = dict["_id"] as? String ?? ""
        
        self.id = id 
        
        var users:[UserModel] = []
        for userDict in usersDict {
            let user = UserModel(dict: userDict)
            users.append(user)
        }
        
        self.users = users
        
        var messages:[MessageModel] = []
        for messageDict in messagesDict {
            let message = MessageModel(dict: messageDict)
            messages.append(message)
        }
        
        self.messages = messages
        
        var cursors:[CursorModel] = []
        for cursorDict in cursorsDict {
            let cursor = CursorModel(dict: cursorDict)
            cursors.append(cursor)
        }
        
        self.cursors = cursors
        
        self.updatedAt = Date()
        
    }
}
