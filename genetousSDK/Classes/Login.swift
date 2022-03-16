//
//  Login.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class Login:NSObject{
    let defaults = UserDefaults.standard
    public init(data: Any? = nil, host: String? = nil) {
        self.data = data
        self.host = host
        self.client = URL_TYPE.client.description
        self.auth = URL_TYPE.auth.description
        self.getUser = URL_TYPE.getCollection.description
        self.applicationId = Bundle.main.object(forInfoDictionaryKey: "applicationId") as? String ?? nil
        self.organizationId = Bundle.main.object(forInfoDictionaryKey: "organizationId") as? String ?? nil
        //self.applicationId = "bff329a2-cb12-4882-b760-cebdbe2c2236"
        //self.organizationId = "61ba6380a6689921e7ad4708"
    }
    
    var data:Any!
    var host:String!
    var client:String!
    var auth:String!
    var getUser:String!
    var applicationId:String!
    var organizationId:String!
    public func process(withBlock callback: @escaping OnComplete){
        getServerResponseForUrlCallback = callback
        if(self.applicationId == nil || self.organizationId == nil){
            let res = responseBuilder()
            res.setExceptionData("Please set applicationId and organizationId at info.plist")
            callback(res.createResponse())
            return
        }
        let c_data:Any=[
            "application_id":applicationId,
            "organization_id":organizationId
        ]
        
        getClient(c_data){response in
            if(response?.ExceptionData==""){
                self.authenticate(response?.JsonObject as Any){auth_res in
                    if(auth_res?.ExceptionData=="" && self.keyExists(dict:(auth_res?.JsonObject)!,key:"token")){
                        let token = auth_res?.JsonObject.value(forKey: "token") as! String
                        self.get_user(token){user_resp in
                            if(user_resp?.ExceptionData=="" && self.keyExists(dict:(user_resp?.JsonObject)!,key:"id")){
                                let cdata:Any=[
                                    "application_id":self.applicationId,
                                    "organization_id":self.organizationId,
                                    "client_id":user_resp?.JsonObject.value(forKey: "id")
                                ]
                                self.getClient(cdata){c_res in
                                    self.authenticate(c_res?.JsonObject as Any){last_res in
                                        if(last_res?.ExceptionData=="" && self.keyExists(dict:(last_res?.JsonObject)!,key:"token")){
                                            
                                            callback(last_res)
                                        }else{
                                            callback(last_res)
                                        }
                                    }
                                }
                            }else{
                                callback(user_resp)
                            }
                        }
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
    func get_user(_ token:String,withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        PostGetBuilder()
            .setHost(self.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(getUser)
            .setToken(token)
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
