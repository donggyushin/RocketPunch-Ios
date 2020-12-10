//
//  UserModel.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import Foundation

struct UserModel {
    var id:String
    var profile:String
    
    init(dict:[String:Any]) {
        let id = dict["id"] as? String ?? ""
        let profile = dict["profile"] as? String ?? ""
        self.id = id
        self.profile = profile
    }
}
