//
//  DataService.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/10.
//

import Foundation
import Firebase

class DataService {
    static let shared = DataService()
    let storage = Storage.storage()
    
    
    func uploadImage(image:UIImage, completion:@escaping(Error?, String?, Bool, String?) -> Void) {
        let uuid = NSUUID().uuidString
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/\(uuid).jpg")
        guard let data = image.pngData() else { return completion(nil, "이미지를 데이터화 시키던 도중에 에러가 발생하였습니다.", false, nil)}
        let uploadTask = profileImageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                return completion(error, nil, false, nil)
            }
            
            profileImageRef.downloadURL { (url, error) in
                if let error = error {
                    return completion(error, nil, false, nil)
                }
                
                guard let url = url else { return }
                let urlString = url.absoluteString
                return completion(nil, nil, true, urlString)
            }
            
        }
        
        uploadTask.resume()
    }
}
