//
//  PostGet.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
protocol completionHandler{
    func onHttpFinished(response:response!)
}
public protocol uploadProgress {
    func progress(uploadProgress:Float)
}
public enum REQUEST_METHODS {
    case POST
    case GET
}

public enum RETURN_TYPE {
    case STRING
    case MAPPER
    case JSONOBJECT
    case JSONARRAY
}

public enum POST_TYPE {
    case MULTIPART
    case JSON
}

public enum URL_TYPE:CustomStringConvertible {
    case addUniqueCollection
    case addCollection
    case updateCollection
    case deleteCollection
    case deleteRelation
    case addRelation
    case getCollection
    case getCollections
    case getRelations
    case removeRelation
    case selectRelation
    case search
    case uploadFile
    case deleteFile
    case getFileList
    case sendMail
    case sendMobileNofication
    case sendDBJob
    case mapCollectionAnalytics
    case client
    case auth
    case verify
    
    public var description : String {
        switch self {
        case .addUniqueCollection: return ":5004/add/unique/collection"
        case .addCollection: return ":5004/add/collection"
        case .updateCollection: return ":5004/update/collection"
        case .deleteCollection: return ":5004/delete/collection"
        case .deleteRelation: return ":5004/delete/relation"
        case .addRelation: return ":5004/add/relation"
        case .getCollection: return ":5004/get/collection"
        case .getCollections: return ":5004/get/collections"
        case .getRelations: return ":5004/get/relations"
        case .removeRelation: return ":5004/remove/relation"
        case .selectRelation: return ":5004/select/relation"
        case .search: return ":5004/search"
        case .uploadFile: return ":5002/upload/file"
        case .deleteFile: return ":5002/delete"
        case .getFileList: return ":5002/get/list"
        case .sendMail: return ":5001/send/mail"
        case .sendMobileNofication: return ":5001/send/notification"
        case .sendDBJob: return ":5003/add/dbjob"
        case .mapCollectionAnalytics: return ":5014/map"
        case .client: return ":5008/client"
        case .auth: return ":5008/auth"
        case .verify: return ":5008/verify"
        }
    }
}

public typealias OnComplete = (_ response:response?)->Void
public typealias OnComplete2 = (_ response:Data?)->Void
var getServerResponseForUrlCallback: OnComplete!
var getServerResponseForUrlCallback2: OnComplete2!
public class PostGet:NSObject,URLSessionTaskDelegate{
    
    internal init(host: String? = nil, url_type: String? = nil, jsonPostData: Any? = nil, parameters: [Any]? = nil, method: REQUEST_METHODS? = nil, post_type: POST_TYPE? = nil, token: String? = nil, return_type: RETURN_TYPE? = nil, requestCode: Int? = nil, postFile: String? = nil, delegate: uploadProgress? = nil) {
        self.host = host
        self.url_type = host! + url_type!
        self.jsonPostData = jsonPostData
        self.parameters = parameters
        self.method = method
        self.post_type = post_type
        self.token = token
        self.return_type = return_type
        self.requestCode = requestCode
        self.postFile = postFile
        self.delegate = delegate
    }
    
    var host:String!
    var url_type:String!
    var jsonPostData:Any!
    var parameters:[Any]!
    var method:REQUEST_METHODS!
    var post_type:POST_TYPE!
    var token:String!
    var return_type:RETURN_TYPE!
    var requestCode:Int!
    var postFile:String!
    var delegate:uploadProgress!
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        if(self.delegate != nil){
            self.delegate.progress(uploadProgress: uploadProgress)
        }
    }
    public func process(withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        let res = responseBuilder()
        if(post_type==POST_TYPE.JSON){
            let defaultConfigObject: URLSessionConfiguration = URLSessionConfiguration.default
            let delegateFreeSession: URLSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
            let url: URL = URL(string: url_type)!
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                let d=try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                let strr = String(decoding: d, as: UTF8.self)
                print(strr)
            } catch {
                print(error)
                return
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            if(token != nil && token != ""){
                urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            var dataTask = URLSessionDataTask()
            
            dataTask = delegateFreeSession.dataTask(with: urlRequest) { data, response, errors in
                
                do {
                    var str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    if(self.return_type == RETURN_TYPE.JSONOBJECT){
                        if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:AnyObject] {
                            let jo:NSDictionary = jsonOutput as NSDictionary
                            
                            res.setJsonObject(jo)
                                .setExceptionData("")
                            callback(res.createResponse())
                        }else{
                            res.setExceptionData("Hata")
                            callback(res.createResponse())
                        }
                    }else if(self.return_type == RETURN_TYPE.JSONARRAY){
                        if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [[String:AnyObject]] {
                            let ja:[NSDictionary] = jsonOutput as [NSDictionary]
                            
                            res.setJsonArray(ja)
                                .setExceptionData("")
                            callback(res.createResponse())
                        }else{
                            res.setExceptionData("Hata")
                            callback(res.createResponse())
                        }
                    }else if(self.return_type == RETURN_TYPE.STRING){
                        let str = String(decoding: data!, as: UTF8.self)
                        res.setJsonData(jsonData:str)
                            .setExceptionData("")
                        callback(res.createResponse())
                        
                    }
                } catch {
                    res.setExceptionData("Hata")
                    callback(res.createResponse())
                }
                
            }
            dataTask.resume()
            
        }
        else if(post_type==POST_TYPE.MULTIPART){
            let defaultConfigObject: URLSessionConfiguration = URLSessionConfiguration.default
            let delegateFreeSession: URLSession = URLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: OperationQueue.main)
            let url: URL = URL(string: url_type)!
            var urlRequest: URLRequest = URLRequest(url: url,timeoutInterval: Double.infinity)
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()
            for param in parameters as! [[String:Any]] {
                if param["disabled"] == nil {
                    let paramName = param["key"]!
                    body.append(("--\(boundary)\r\n").data(using: .utf8)!)
                    body.append(("Content-Disposition:form-data; name=\"\(paramName)\"").data(using: .utf8)!)
                    if param["contentType"] != nil {
                        body.append(("\r\nContent-Type: \(param["contentType"] as! String)").data(using: .utf8)!)
                    }
                    let paramType = param["type"] as! String
                    let paramValue = param["value"] as! String
                    body.append(("\r\n\r\n\(paramValue)\r\n").data(using: .utf8)!)
                    
                }
            }
            body.append(("--\(boundary)\r\n").data(using: .utf8)!)
            body.append(("Content-Disposition:form-data; name=\"file\"").data(using: .utf8)!)
            do{
                let fileData = try NSData(contentsOfFile:self.postFile, options:[]) as Data
                body.append(("; filename=\"\(URL(fileURLWithPath: self.postFile).lastPathComponent)\"\r\n").data(using: .utf8)!)
                body.append(("Content-Type: application/octet-stream\r\n\r\n").data(using: .utf8)!)
                body.append(fileData as Data)
                body.append(("\r\n").data(using: .utf8)!)
            }catch{
                res.setExceptionData(error.localizedDescription)
                callback(res.createResponse())
                return
            }
            body.append(("--\(boundary)--\r\n").data(using: .utf8)!)
            
            let postData = body
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = postData
            
            var dataTask = URLSessionDataTask()
            dataTask = delegateFreeSession.dataTask(with: urlRequest){data, response, errors in
                do {
                    var str = String(decoding: data!, as: UTF8.self)
                    res.setJsonData(jsonData:str)
                        .setExceptionData("")
                    callback(res.createResponse())
                    
                } catch {
                    res.setExceptionData("Hata")
                    callback(res.createResponse())
                }
            }
            dataTask.resume()
        }
        
    }
    public func process2(withBlock callback: @escaping OnComplete2) {
        getServerResponseForUrlCallback2 = callback
        for param in parameters as! [[String:Any]] {
            if param["disabled"] == nil {
                let paramType = param["type"] as! String
                if paramType == "text" {
                   
                } else {
                    let paramSrc = param["src"] as! String
                    do{
                        let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                        let fileContent = NSString(data: fileData, encoding: String.Encoding.utf8.rawValue)
                        let d:Data=fileContent!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
                        callback(d)
                    }catch{
                        
                        return
                    }
                }
            }
        }
    }
}

