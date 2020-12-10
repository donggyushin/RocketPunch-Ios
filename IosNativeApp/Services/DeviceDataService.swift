//  DeviceDataService.swift
//  IosNativeApp
//  Created by 신동규 on 2020/12/09.

import Foundation

class DeviceDataService {
    
    static let shared = DeviceDataService()
    
    let defaults = UserDefaults.standard
    
    func removingDeviceData(key:String) {
        defaults.removeObject(forKey: key)
    }
    
    func settingDeviceData(key:String, value:String) {
        defaults.set(value, forKey: key)
    }
    
    func gettingDeviceData(key:String) -> String? {
        return defaults.string(forKey: key)
    }
    
}
