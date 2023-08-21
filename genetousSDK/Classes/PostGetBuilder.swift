//
//  PostGetBuilder.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class PostGetBuilder:NSObject{
    public private(set) var host:String!
    public private(set) var url_type:String!
    public private(set) var jsonPostData:Any!
    public private(set) var parameters:[Any]!
    public private(set) var method:REQUEST_METHODS!
    public private(set) var post_type:POST_TYPE!
    public private(set) var token:String!
    public private(set) var return_type:RETURN_TYPE!
    public private(set) var requestCode:Int!
    public private(set) var postFile:String!
    public private(set) var delegate:uploadProgress!
    
    public func setUrlType(_ url_type:String) -> PostGetBuilder {
        self.url_type = url_type
        return self
    }
    public func setHost(_ host:String) -> PostGetBuilder{
        self.host=host
        return self
    }
    public func setJsonPostData(_ jsonPostData:Any) -> PostGetBuilder{
        self.jsonPostData = jsonPostData
        return self
    }
    
    public func setParameters(_ parameters:[Any]) -> PostGetBuilder{
        self.parameters=parameters
        return self
    }
    
    public func setMethod(_ method:REQUEST_METHODS) -> PostGetBuilder{
        self.method = method
        return self
    }
    
    public func setToken(_ token:String) -> PostGetBuilder{
        self.token = token
        return self
    }
    
    public func setReturn_type(_ return_type:RETURN_TYPE) -> PostGetBuilder{
        self.return_type = return_type
        return self
    }
    public func setPost_type(_ post_type:POST_TYPE) -> PostGetBuilder{
        self.post_type = post_type
        return self
    }
    
    
    public func setRequestCode(_ requestCode:Int) -> PostGetBuilder{
        self.requestCode = requestCode
        return self
    }
    
    public func setPostFile(_ postFile:String) -> PostGetBuilder{
        self.postFile = postFile
        return self
    }
    public func setDelegate(_ delegate:uploadProgress) -> PostGetBuilder{
        self.delegate = delegate
        return self
    }
    public func createPost() -> PostGet {
        return genetousSDK.PostGet(host:self.host,
                                   url_type:self.url_type,
                                   jsonPostData:self.jsonPostData,
                                   parameters:self.parameters,
                                   method:self.method,
                                   post_type:self.post_type,
                                   token:self.token,
                                   return_type:self.return_type,
                                   requestCode: self.requestCode,
                                   postFile: self.postFile,
                                   delegate: self.delegate
        )
    }
}
