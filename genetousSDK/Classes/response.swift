//
//  response.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public enum HttpSuccess{
    case SUCCESS
    case FAIL
}
public class response:NSObject{
    internal init(ResponseCode: Int? = nil, Data: String? = nil, MapperData: Any? = nil, JsonObject: NSDictionary? = nil, JsonArray: [NSDictionary]? = nil, ExceptionData: String? = nil, RequestCode: Int? = nil, Result: HttpSuccess? = nil) {
        self.ResponseCode = ResponseCode
        self.Data = Data
        self.MapperData = MapperData
        self.JsonObject = JsonObject
        self.JsonArray = JsonArray
        self.ExceptionData = ExceptionData
        self.RequestCode = RequestCode
        self.Result = Result
    }
    
    public private(set) var ResponseCode:Int!
    public private(set) var Data:String!
    public private(set) var MapperData:Any!
    public private(set) var JsonObject:NSDictionary!
    public private(set) var JsonArray:[NSDictionary]!
    public private(set) var ExceptionData:String!
    public private(set) var RequestCode:Int!
    public private(set) var Result:HttpSuccess!
    
}
