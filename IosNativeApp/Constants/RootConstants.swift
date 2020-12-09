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
}
