//
//  KillToken.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class KillToken:NSObject{
    let defaults = UserDefaults.standard
    public init(host: String? = nil,token: String? = nil) {
        self.host = host
        self.token = token
    }
    
    var host:String!
    var token:String!
    public func process(withBlock callback: @escaping OnComplete){
        getServerResponseForUrlCallback = callback
        killToken(){response in
            callback(response)
        }
    }
    func killToken(withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        PostGetBuilder()
            .setHost(self.host)
            .setToken(self.token)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.killToken.description)
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


