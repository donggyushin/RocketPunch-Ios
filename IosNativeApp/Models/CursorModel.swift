//
//  CursorModel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/13.
//

import Foundation


struct  CursorModel {
    var user:UserModel
    var recentReadMessageId:Int
    
    init(dict:[String:Any]) {
        let userDict = dict["user"] as? [String:Any] ?? ["fail":"fail"]
        let recentReadMessageId = dict["recentReadMessageId"] as? Int ?? 1
        
        let user = UserModel(dict: userDict)
        
        self.user = user
        self.recentReadMessageId = recentReadMessageId
    }
}
