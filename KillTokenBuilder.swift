//
//  KillTokenBuilder.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class KillTokenBuilder:NSObject {
    
    public private(set) var  token:String!
    public private(set) var  host:String!

    
    public func setToken(_ token:String) ->KillTokenBuilder {
        self.token = token;
        return self;
    }

    public func setHost(_ host:String) ->KillTokenBuilder {
        self.host = host;
        return self;
    }

    public func kill() -> KillToken {
        return genetousSDK.KillToken(host: self.host,token: self.token)
    }
}
