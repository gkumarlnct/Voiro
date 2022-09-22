//
//  WebService.swift
//  Qschoolgolf
//
//  Created by Baltej Singh on 06/01/20.
//  Copyright © 2020 Wegile. All rights reserved.
//

import UIKit


class WebService: NSObject
{
    static var webservice_running : Int = 0
    
    
    
    

    
    
    func requestWithBasicGET(_ url:String,param:NSDictionary, success:@escaping(NSDictionary)->Void, failure:@escaping()->Void)
        {
        
        WebService.webservice_running = WebService.webservice_running + 1
            
            DispatchQueue.global(qos: .background).async {
            let actualURL = URL.init(string: url)
            let request = NSMutableURLRequest.init(url: actualURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.httpMethod = "GET"

            let session = URLSession.shared
            session.dataTask(with: request as URLRequest){ data, response, error in
                
                if let error = error
                {
                    print("Error :: ",error)
//                    SVProgressHUD.dismiss()
                    
                    DispatchQueue.main.async {
                        success(NSDictionary())
//                        CommonMethods.presentCustomAlert(AlertTitle().ERROR,message: "Server busy,please try again.", buttons: AlertButtons().arrOK, delegate: self, onVC: AppDelegate.sharedAppDelegate()!.topViewController()!)
                    }
                    
                    
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print(response)
    //                let statusCode = response.value(forKey: "Status Code") as! Int
                    if response.statusCode != 200
                    {
//                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                            success(NSDictionary())
//                            CommonMethods.presentCustomAlert(AlertTitle().ERROR,message: "Server busy,please try again.", buttons: AlertButtons().arrOK, delegate: self, onVC: AppDelegate.sharedAppDelegate()!.topViewController()!)
                            return
                        }
                       
                    }
                }
                if let data = data {
                    do {
                        let strStatus = String.init(data: data, encoding: String.Encoding.init(rawValue: 0))
                        print(url+strStatus!)
                        print(param)
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        DispatchQueue.main.async {
                            success(json as! NSDictionary)
                            print(json)
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            print("Error :: ",error)
//                            SVProgressHUD.dismiss()
                            
                             DispatchQueue.main.async {
                            success(NSDictionary())
//                            CommonMethods.presentCustomAlert(AlertTitle().ERROR,message: "Server busy,please try again.", buttons: AlertButtons().arrOK, delegate: self, onVC: AppDelegate.sharedAppDelegate()!.topViewController()!)
                            }
                        }
                        
                    }
                }
                
                WebService.webservice_running = WebService.webservice_running - 1
                }.resume()
            }
        }
    
}

// encoded NSMutableDictionary
extension NSMutableDictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

// convert NSMutableDictionary to jsonString
extension NSMutableDictionary {
    var jsonStringRepresentation: String? {

        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .utf8)
    }
}


extension NSDictionary
{
    
    func getIntDataFromKey(key : String) -> Int?{
        if let idValue = self[key] as? Int{
            return idValue
        }else if let idValue = self[key] as? String{
            return Int(idValue)!
        }else if let idValue = self[key] as? Double{
            return Int(idValue)
        }
        else{
            return nil
        }
    }
    
    func getStringDataFromKey(key : String) -> String?{
        if let idValue = self[key] as? String{
            return idValue
        }else if let idValue = self[key] as? Int{
            return String(idValue)
        }else if let idValue = self[key] as? Double{
            return String(idValue)
        }
        else{
            return nil
        }
    }
}
