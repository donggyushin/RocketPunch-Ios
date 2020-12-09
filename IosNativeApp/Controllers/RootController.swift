//
//  RootController.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

class RootController: UITabBarController {
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        appInit()
        
    }
    
    

}


// MARK: - Configures
extension RootController {
    
    
    func configureControllers() {
        viewControllers = []
        let usersController = UsersController()
        let chatsController = ChatsController()
        
        let usersControllerNavigation = UINavigationController(rootViewController: usersController)
        let chatsControllerNavigation = UINavigationController(rootViewController: chatsController)
        
        usersControllerNavigation.tabBarItem.image = #imageLiteral(resourceName: "icons8-search-100 2")
        usersControllerNavigation.tabBarItem.title = "유저"
        chatsControllerNavigation.tabBarItem.image = #imageLiteral(resourceName: "icons8-chat-bubble-100 2")
        chatsControllerNavigation.tabBarItem.title = "채팅"
        
        viewControllers = [
            usersControllerNavigation,
            chatsControllerNavigation
        ]
    }
}

// MARK: Helpers
extension RootController {
    func appInit() {
        
        let token = DeviceDataService.shared.gettingDeviceData(key: AuthConstants.AUTH_TOKEN)
        
        if token == nil {
            
            presentAuthController()

        }else {
            
            loginUser(token: token!)
        }
    }
    
    func presentAuthController() {
        let signInController = SignInController()
        let signInNavigationController = UINavigationController(rootViewController: signInController)
        
        signInNavigationController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.present(signInNavigationController, animated: false, completion: nil)
        }
    }
    
    func loginUser(token:String) {
        DeviceDataService.shared.settingDeviceData(key: AuthConstants.AUTH_TOKEN, value: token)
        configureControllers()
    }
    
}
