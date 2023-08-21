//
//  ViewController.swift
//  genetousSDK
//
//  Created by omeryil on 02/28/2022.
//  Copyright (c) 2022 omeryil. All rights reserved.
//

import UIKit
import genetousSDK
import MobileCoreServices

class ViewController: UIViewController,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,uploadProgress {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "PostItemCell", for: indexPath as IndexPath) as! PostItemCell
        let item:String=post_items[indexPath.row]
        cell.item.text=item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position=indexPath.row
        DispatchQueue.main.async(execute: { [self] in
            switch (position) {
            case 0:
                getGuestToken();
                break;
             case 1:
                login();
                break;
            case 2:
                verifyToken();
                break;
            case 3:
                killToken()
                break;
            case 4:
                addCollection();
                break;
            case 5:
                addUniqueCollection();
                break;
            case 6:
                addRelation();
                break;
            case 7:
                getRelation();
                break;
            case 8:
                getCollection();
                break;
            case 9:
                updateCollection();
                break;
            case 10:
                deleteCollection();
                break;
            case 11:
                isUnique();
                break;
            case 12:
                createSecureLink();
                break;
            case 13:
                uploadFile();
                
                break;
            case 14:
                getFileList();
                break;
            case 15:
                deleteFile();
                break;
            default:
                break
            }
        });
    }
    func progress(uploadProgress: Float) {
        DispatchQueue.main.async {
            self.tv.text = String(format: "%.2f", uploadProgress*100)+"% ....."
        }
    }
    
    @IBOutlet weak var itemsTable: UITableView!
    let host:String = "http://192.168.0.20/"
    let postGetBuilder = PostGetBuilder()
    let defaults = UserDefaults.standard
    @IBOutlet weak var fileUploadBT: UIButton!
    @IBOutlet weak var imv: UIImageView!
    var imagePicker = UIImagePickerController()
    var post_items:[String]=[]
    @IBOutlet weak var tv: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        post_items.append("GetGuestToken");
        post_items.append("Login");
        post_items.append("Verify Token");
        post_items.append("Kill Token");
        post_items.append("Add Collection");
        post_items.append("Add Unique Collection");
        post_items.append("Add Relation");
        post_items.append("Get Relations");
        post_items.append("Get Collections");
        post_items.append("Update Collections");
        post_items.append("Delete Collections");
        post_items.append("Is Unique");
        post_items.append("Create Secure Link");
        post_items.append("Upload File");
        post_items.append("Get File List");
        post_items.append("Delete Files");
        itemsTable.delegate=self
        itemsTable.dataSource=self
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        var imageURL=""
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
                print(imgUrl.relativePath)
                print(imgUrl.absoluteURL)
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                let data = UIImageJPEGRepresentation(image,50)! as NSData
                data.write(toFile: localPath!, atomically: true)
                let ima = UIImage(data: data as Data)
                
                imageURL=localPath!
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        let data:[Any] = [
            [
              "key": "random",
              "value": "true",
              "type": "text"
            ]]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setParameters(data)
            .setPost_type(POST_TYPE.MULTIPART)
            .setPostFile(imageURL)
            .setToken(t)
            .setUrlType(URL_TYPE.uploadFile.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .setDelegate(self)
            .createPost()
            .process(){response in
                DispatchQueue.main.async {
                    self.tv.text.append("\n"+self.dicToStr(dict: (response?.JsonObject)!))
                }
                
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func login() {
    
        let and:Any=[
            "username":"genetousUser",
            "userpass":"12345678"
        ]
        let andData:Any=["and":and]
        let data:Any=["where":andData]
        LoginBuilder()
            .setHost(host)
            .setData(data)
            .createLogin()
            .process(){response in
                let d = response as response?
                let a = (d?.ExceptionData ?? "Hata") as String
                if(a==""){
                    let p=d?.JsonObject.value(forKey: "token") as! String
                    self.defaults.set(p, forKey: "token")
                    DispatchQueue.main.async {
                        self.tv.text=self.dicToStr(dict: (d?.JsonObject)!)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.tv.text=a as String
                    }
                }
            }
    }
    func getGuestToken() {

        GuestTokenBuilder()
            .setHost(host)
            .createToken()
            .process(){response in
                let d = response as response?
                let a = (d?.ExceptionData ?? "Hata") as String
                if(a==""){
                    let p=d?.JsonObject.value(forKey: "token") as! String
                    self.defaults.set(p, forKey: "token")
                    DispatchQueue.main.async {
                        self.tv.text=self.dicToStr(dict: (d?.JsonObject)!)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.tv.text=a as String
                    }
                }
            }
    }
    func verifyToken() {
        let token=self.defaults.string(forKey: "token") ?? ""
        VerifyBuilder()
            .setHost(host)
            .setToken(token)
            .verify()
            .process(){response in
                let d = response as response?
                let a = (d?.ExceptionData ?? "Hata") as String
                if(a==""){
                    let p=d?.JsonObject.value(forKey: "success") as! Bool
                    DispatchQueue.main.async {
                        self.tv.text=self.dicToStr(dict: (d?.JsonObject)!)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.tv.text=a as String
                    }
                }
            }
    }
    func killToken() {
        let token=self.defaults.string(forKey: "token") ?? ""
        KillTokenBuilder()
            .setHost(host)
            .setToken(token)
            .kill()
            .process(){response in
                let d = response as response?
                let a = (d?.ExceptionData ?? "Hata") as String
                if(a==""){
                    DispatchQueue.main.async {
                        self.tv.text=self.dicToStr(dict: (d?.JsonObject)!)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.tv.text=a as String
                    }
                }
            }
    }
    func addCollection(){
        let data:Any=[
            "collectionName": "test",
            "content": [
                "data1": "val1",
                "data2": "val2",
                "data3": "val3"
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.addCollection.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func addUniqueCollection(){
        let uniqueFields:[String]=["data1"]
        let data:Any=[
            "collectionName": "test",
            "content": [
                "data1": "val78",
                "data2": "val2",
                "data3": "val3",
                "uniqueFields":uniqueFields
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.addUniqueCollection.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func addRelation(){
        let relations:[Any]=[["relationName":"testRelations","id":"64e28c41c84e623c3deb6035"]]
        let contents:[Any]=[["id":"64e28addc84e623c3deb6030"]]
        let data:Any=[
            "relations": relations,
            "contents": contents
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.addRelation.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func getRelation(){
        let data:Any=[
            "where":[
                "and":[
                    "relationName":"testRelations"
                ]
            ],
            "related":[
                "collectionName":"test",
                "from":0,
                "size":1,
                "sort":[
                    "data1":"desc"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.getRelations.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func getCollection(){
        let data:Any=[
            "where":[
                "and":[
                    "collectionName":"test"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.getCollections.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func updateCollection(){
        let data:Any=[
            "where":[
                "and":[
                    "productName":"X Shoes"
                ]
            ],
            "fields":[
                [
                    "field":"productBrand",
                    "value":"YY Brand"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.updateCollection.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func deleteCollection(){
        let data:Any=[
            "where":[
                "and":[
                    "data1":"val78"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.deleteCollection.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func isUnique(){
        let data:Any=[
            "where":[
                "and":[
                    "collectionName":"user",
                    "username":"genetousUserd"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.isUnique.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func createSecureLink(){
        let data:Any=[
            "collectionName":"user",
            "usermail":"genetous@genetous.com",
            "update":"userpass"
              
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.createSecureLink.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func uploadFile(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func getFileList(){
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setMethod(REQUEST_METHODS.GET)
            .setToken(t)
            .setUrlType(URL_TYPE.getFileList.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func deleteFile(){
        let files:[String]=["xsuif6u6atwujmdt.txt"]
        let data:Any=[
            "files":files
              
        ]
        let t = defaults.object(forKey: "token") as! String
        PostGetBuilder()
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.deleteFile.description)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setHost(host)
            .createPost()
            .process(){response in
                print(response?.ResponseCode)
                let p=response?.JsonObject
                DispatchQueue.main.async { [self] in
                    self.tv.text=dicToStr(dict: p!)
                }
                
            }
    }
    func dicToStr(dict:NSDictionary)->String {
        do{
            let jd = try JSONSerialization.data(withJSONObject:dict)
            if let json = String(data: jd, encoding: .utf8){
                return json
            }
        }catch {
            return "Convertion Error"
        }
        return ""
    }
}

