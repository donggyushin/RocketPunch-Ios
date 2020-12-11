//
//  UserService.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import Foundation
import Alamofire

class UserService {
    static let shared = UserService()
    
    func fetchMe(token:String, completion:@escaping(Error?, String?, Bool, UserModel?) -> Void) {
        let urlString = "\(EndpointConstants.shared.ROCKET_PUNCH_API)/user/me"
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: ["authorization": "Bearer \(token)"], interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                return completion(error, nil, false, nil)
            case .success(let value):
                guard let value = value as? [String:Any] else { return }
                guard let ok = value["ok"] as? Bool else { return }
                if !ok {
                    guard let message = value["message"] as? String else { return }
                    return completion(nil, message, false, nil)
                }else {
                    guard let userDict = value["user"] as? [String:Any] else { return }
                    let user = UserModel(dict: userDict)
                    return completion(nil, nil, true, user)
                }
            }
        }
    }
    
    func fetchUserList(completion:@escaping(Error?, String?, Bool, [UserModel]) -> Void) {
        var userList:[UserModel] = []
        let urlString = "\(EndpointConstants.shared.ROCKET_PUNCH_API)/user/list"
        guard let url = URL(string: urlString) else { return completion(nil, "url 객체 생성 실패", false, userList)}
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                return completion(error, nil, false, userList)
            case .success(let value):
                guard let value = value as? [String:Any] else { return }
                guard let ok = value["ok"] as? Bool else { return }
                if ok == false {
                    guard let message = value["message"] as? String else { return }
                    return completion(nil, message, false, userList)
                }
                
                guard let userListDict = value["users"] as? [[String:Any]] else { return }
                
                for item in userListDict {
                    
                    let user = UserModel(dict: item)
                    
                    
                    userList.append(user)
                }
                return completion(nil, nil, true, userList)
            }
        }
    }
    
    func signIn(id:String, pw:String, completion:@escaping(Error?, String?, Bool, UserModel?, String?) -> Void) {
        let urlString = "\(EndpointConstants.shared.ROCKET_PUNCH_API)/user/login"
        guard let url = URL(string: urlString) else { return completion(nil, "url 객체 생성 실패", false, nil, nil)}
        let parameters = [
            "id":id,
            "pw":pw
        ]
        AF.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                return completion(error, nil, false, nil, nil)
            case .success(let value):
                guard let value = value as? [String:Any] else { return }
                guard let ok = value["ok"] as? Bool else { return }
                if ok == false {
                    guard let message = value["message"] as? String else { return }
                    return completion(nil, message, false, nil, nil)
                }else {
                    guard let userDict = value["user"] as? [String:Any] else { return }
                    guard let token = value["token"] as? String else { return }
                    let user = UserModel(dict: userDict)
                    return completion(nil, nil, true, user, token)
                }
            }
        }
    }
    
    func signUp(id:String, pw:String, profile:String, completion:@escaping(Error?, String?, Bool) -> Void) {
        let urlString = "\(EndpointConstants.shared.ROCKET_PUNCH_API)/user"
        guard let url = URL(string: urlString) else { return completion(nil, "url 객체 생성 실패", false)}
        let parameters = [
            "id":id,
            "pw":pw,
            "profile":profile
        ]
        AF.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                return completion(error, nil, false)
            case .success(let value):
                guard let value = value as? [String:Any] else { return }
                guard let ok = value["ok"] as? Bool else { return }
                if ok == false {
                    guard let message = value["message"] as? String else { return }
                    return completion(nil, message, false)
                }else {
                    return completion(nil, nil, true)
                }
            }
        }
    }
}
