//
//  func.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
public class responseBuilder:NSObject {
    public private(set) var responseCode:Int!
    public private(set) var jsonData:String!
    public private(set) var jsonObject:NSDictionary!
    public private(set) var jsonArray:[NSDictionary]!
    public private(set) var exceptionData:String!
    public private(set) var requestCode:Int!
    public private(set) var result:HttpSuccess!
    
    public func setResponseCode(_ responseCode:Int) -> responseBuilder {
        self.responseCode = responseCode
        return self
    }
    
    public func setJsonData(jsonData:String) -> responseBuilder {
        self.jsonData = jsonData
        return self
    }
    
    
    public func setExceptionData(_ exceptionData:String) -> responseBuilder {
        self.exceptionData = exceptionData
        return self
    }
    
    public func setRequestCode(_ requestCode:Int) -> responseBuilder {
        self.requestCode = requestCode
        return self
    }
    
    public func setResult(_ result:HttpSuccess ) -> responseBuilder {
        self.result = result
        return self
    }
    
    public func setJsonObject(_ jsonObject:NSDictionary) -> responseBuilder {
        self.jsonObject = jsonObject
        return self
    }
    
    public func setJsonArray(_ jsonArray:[NSDictionary]) -> responseBuilder {
        self.jsonArray = jsonArray
        return self
    }
    public func createResponse() -> response {
        return genetousSDK.response(ResponseCode: self.responseCode, Data: self.jsonData, MapperData: nil, JsonObject: self.jsonObject, JsonArray: self.jsonArray, ExceptionData: self.exceptionData, RequestCode: self.requestCode, Result: self.result)
    }
}
