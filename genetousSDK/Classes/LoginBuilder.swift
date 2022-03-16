//
//  LoginBuilder.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class LoginBuilder:NSObject {
    
    public private(set) var  data:Any!
    public private(set) var  host:String!

    
    public func setData(_ data:Any) ->LoginBuilder {
        self.data = data;
        return self;
    }

    public func setHost(_ host:String) ->LoginBuilder {
        self.host = host;
        return self;
    }

    public func createLogin() -> Login {
        return genetousSDK.Login(data: self.data, host: self.host)
    }
}
