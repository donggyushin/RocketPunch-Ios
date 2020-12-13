//
//  MessageModel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import Foundation


struct MessageModel {
    var messageId:Int
    var user:UserModel
    var createdAt: Date
    var text:String
    
    init(dict:[String:Any]) {
        let messageId = dict["messageId"] as? Int ?? 0
        let userDict = dict["user"] as? [String:Any] ?? ["key":"value"]
        let createdAtString = dict["createdAt"] as? String ?? ""
        let text = dict["text"] as? String ?? ""
        
        let user = UserModel(dict: userDict)
        self.messageId = messageId
        self.user = user
        self.text = text 
        
        let createdAt = DateUtil.shared.convertJsonDateToSwiftDate(jsonDate: createdAtString)
        self.createdAt = createdAt
        
    }
}
