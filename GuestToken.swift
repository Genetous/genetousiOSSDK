//
//  GuestToken.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class GuestToken:NSObject{
    let defaults = UserDefaults.standard
    public init(host: String? = nil) {
        self.host = host
        self.client = URL_TYPE.client.description
        self.auth = URL_TYPE.auth.description
        self.applicationId = Bundle.main.object(forInfoDictionaryKey: "applicationId") as? String ?? nil
        self.organizationId = Bundle.main.object(forInfoDictionaryKey: "organizationId") as? String ?? nil
        self.secretKey = Bundle.main.object(forInfoDictionaryKey: "secretKey") as? String ?? nil
    }
    
    var host:String!
    var client:String!
    var auth:String!
    var applicationId:String!
    var organizationId:String!
    var secretKey:String!
    public func process(withBlock callback: @escaping OnComplete){
        getServerResponseForUrlCallback = callback
        if(self.applicationId == nil || self.organizationId == nil || self.secretKey == nil){
            let res = responseBuilder()
            res.setExceptionData("Please set applicationId and organizationId at info.plist")
            callback(res.createResponse())
            return
        }
        let c_data:Any=[
            "applicationId":applicationId,
            "organizationId":organizationId
        ]
        
        getClient(c_data){response in
            if(response?.ExceptionData==""){
                var obj:Dictionary=response?.JsonObject as! Dictionary<String, Any>
                obj["clientSecret"]=self.secretKey
                self.authenticate(obj as Any){auth_res in
                    if(auth_res?.ExceptionData=="" && self.keyExists(dict:(auth_res?.JsonObject)!,key:"token")){
                        callback(auth_res)
                    }else{
                        callback(auth_res)
                    }
                }
            }else{
                callback(response)
            }
        }
    }
    func getClient(_ c_data:Any,withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        PostGetBuilder()
            .setHost(self.host)
            .setJsonPostData(c_data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(client)
            .createPost()
            .process(){response in
                callback(response)
            }
    }
    func authenticate(_ c_data:Any,withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        PostGetBuilder()
            .setHost(self.host)
            .setJsonPostData(c_data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(auth)
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
