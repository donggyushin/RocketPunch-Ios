//
//  ChatService.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/12.
//

import Foundation
import Alamofire

class ChatService {
    static let shared = ChatService()
    
    func fetchRoomId(userIds:[String], completion:@escaping(Error?, String?, Bool, String?) -> Void) {
        var userIdsQuery = ""
        for userId in userIds {
            userIdsQuery += "\(userId),"
        }
        userIdsQuery.remove(at: userIdsQuery.index(before: userIdsQuery.endIndex))
        
        let urlString = "\(EndpointConstants.shared.ROCKET_PUNCH_API)/chat/id?userIdsString=\(userIdsQuery)"
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { (response) in
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
                    guard let chatRoomId = value["chatRoomId"] as? String else { return }
                    return completion(nil, nil, true, chatRoomId)
                }
            }
        }
    }
}
