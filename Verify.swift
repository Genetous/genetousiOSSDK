//
//  Verify.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

//
//  GuestToken.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class Verify:NSObject{
    let defaults = UserDefaults.standard
    public init(host: String? = nil,token: String? = nil) {
        self.host = host
        self.token = token
    }
    
    var host:String!
    var token:String!
    public func process(withBlock callback: @escaping OnComplete){
        getServerResponseForUrlCallback = callback
        verifyToken(){response in
            callback(response)
        }
    }
    func verifyToken(withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        PostGetBuilder()
            .setHost(self.host)
            .setToken(self.token)
            .setMethod(REQUEST_METHODS.GET)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.verify.description)
            .createPost()
            .process(){response in
                callback(response)
            }
    }
    func keyExists(dict:NSDictionary,key:String) ->Bool {
        if dict[key] == nil {
            return false
        } else {
            return true
        }
    }
}

