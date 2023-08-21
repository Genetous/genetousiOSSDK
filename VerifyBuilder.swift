//
//  VerifyBuilder.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class VerifyBuilder:NSObject {
    
    public private(set) var  token:String!
    public private(set) var  host:String!

    
    public func setToken(_ token:String) ->VerifyBuilder {
        self.token = token;
        return self;
    }

    public func setHost(_ host:String) ->VerifyBuilder {
        self.host = host;
        return self;
    }

    public func verify() -> Verify {
        return genetousSDK.Verify(host: self.host,token: self.token)
    }
}

