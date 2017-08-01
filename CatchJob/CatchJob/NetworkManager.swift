//
//  NetworkManager.swift
//  CatchJob
//
//  Created by 陈秀鹏 on 2017/8/2.
//  Copyright © 2017年 com.linglustudio. All rights reserved.
//

import Foundation
import Alamofire

private let NetworkManagerShareInstance = NetworkManager()
private let BaseUrl = "https://raw.githubusercontent.com/catchnz/ios-test/master/data/"

class NetworkManager: NSObject {
    class var sharedInstance : NetworkManager {
        return NetworkManagerShareInstance
    }
}

extension NetworkManager {
    // get
    func getRequest(urlString: String, params : [String : Any]?, success : @escaping (_ response : [NSDictionary])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(BaseUrl + urlString, method: .get, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [NSDictionary])
                case .failure(let error):
                    failture(error)
                    print("error:\(error)")
                }
        }
        
    }
    
    // post
    func postRequest(urlString : String, params : [String : Any]?, success : @escaping (_ response : [NSDictionary])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(BaseUrl + urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [NSDictionary] {
                    success(value)
                }
            case .failure(let error):
                failture(error)
                print("error:\(error)")
            }
        }
    }
    
}
