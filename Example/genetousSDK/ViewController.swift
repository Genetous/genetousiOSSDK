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

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,uploadProgress {
    func progress(uploadProgress: Float) {
        DispatchQueue.main.async {
            self.token_text.text = String(format: "%.2f", uploadProgress*100)+"%"
        }
    }
    
    let host:String = "your ip address"
    let postGetBuilder = PostGetBuilder()
    let defaults = UserDefaults.standard
    @IBOutlet weak var loginBT: UIButton!
    @IBOutlet weak var addCollection: UIButton!
    @IBOutlet weak var addRelation: UIButton!
    @IBOutlet weak var token_text: UILabel!
    @IBOutlet weak var fileUploadBT: UIButton!
    @IBOutlet weak var imv: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model:Any=[
            "collectionName":"user"
        ]
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        //        postGetBuilder
        //            .setJsonPostData(model)
        //            .setHost(host: URL_TYPE.getCollection.description)
        //            .createPost()
        //            .process(){response in
        //
        //            }
        // Do any additional setup after loading the view, typically from a nib.
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
                imv.image=ima
                imageURL=localPath!
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        token_text.text=imageURL
       
        //return
        let data:[Any] = [
            [
              "key": "bucket",
              "value": "bff329a2-cb12-4882-b760-cebdbe2c2236",
              "type": "text"
            ]]
        let t = defaults.object(forKey: "token") as! String
        postGetBuilder
            .setParameters(data)
            .setPost_type(POST_TYPE.MULTIPART)
            .setPostFile(imageURL)
            .setToken(t)
            .setUrlType(URL_TYPE.uploadFile.description)
            .setReturn_type(RETURN_TYPE.STRING)
            .setHost(host)
            .setDelegate(self)
            .createPost()
            .process(){response in
                DispatchQueue.main.async {
                    self.token_text.text = response?.Data
                }
                
            }
    }
    
    
    @IBAction func logincl(_ sender: Any) {
        login()
    }
    @IBAction func fileUploadCL(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func addRelationCL(_ sender: Any) {
        let data:Any=[
            "relations": [[
                
                "relationName": "frirnds",
                "id": "6220a0975405e4dab7766a8a"
                
            ]],
            "contents": [
                [
                    "id": "6220a1025405e4dab7766a90"
                ]
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        postGetBuilder
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.addRelation.description)
            .setReturn_type(RETURN_TYPE.JSONARRAY)
            .setHost(host)
            .createPost()
            .process(){response in
                if(response?.ExceptionData==""){
                    let d:[NSDictionary]=(response?.JsonArray)!
                    for item in d {
                        print(item)
                    }
                }
                
            }
    }
    @IBAction func addCollectionCL(_ sender: Any) {
        let data:Any=[
            "collectionName": "person",
            "content": [
                "personName": "Caner"
            ]
        ]
        let t = defaults.object(forKey: "token") as! String
        postGetBuilder
            .setJsonPostData(data)
            .setToken(t)
            .setPost_type(POST_TYPE.JSON)
            .setUrlType(URL_TYPE.addCollection.description)
            .setReturn_type(RETURN_TYPE.STRING)
            .setHost(host)
            .createPost()
            .process(){response in
                let p=response?.JsonObject
                
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func login() {
    
        let data:Any=[
            "user_username":"demo",
            "user_password":"demo",
            "remove_fields":["user_password"],
            "type":"login"
        ]
        LoginBuilder()
            .setHost(host)
            .setData(data)
            .createLogin()
            .process(){response in
                let d = response as response?
                let a = (d?.ExceptionData ?? "Hata") as String
                if(a==""){
                    let p=response?.JsonObject.value(forKey: "token") as! String
                    self.defaults.set(p, forKey: "token")
                    DispatchQueue.main.async {
                        self.token_text.text = p
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.token_text.text = a
                    }
                }
            }
    }
    
}

