//
//  GuestTokenBuilder.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class GuestTokenBuilder:NSObject {
    
    public private(set) var  data:Any!
    public private(set) var  host:String!

    
    public func setData(_ data:Any) ->GuestTokenBuilder {
        self.data = data;
        return self;
    }

    public func setHost(_ host:String) ->GuestTokenBuilder {
        self.host = host;
        return self;
    }

    public func createToken() -> GuestToken {
        return genetousSDK.GuestToken(host: self.host)
    }
}
