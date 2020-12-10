//
//  RootConstants.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

class RootConstants {
    static let shared = RootConstants()
    
    let rootController = UIApplication.shared.windows.first!.rootViewController as! RootController
    lazy var usersController:UsersController? = {
        
        guard let usersNavController = rootController.viewControllers?[0] as? UINavigationController else { return nil}
        guard let usersController = usersNavController.viewControllers[0] as? UsersController else { return nil}
        return usersController
    }()
    
    lazy var chatsController:ChatsController? = {
        guard let chatsNavController = rootController.viewControllers?[1] as? UINavigationController else { return nil}
        guard let chatsController = chatsNavController.viewControllers[0] as? ChatsController else { return nil}
        return chatsController
    }()
}
