//
//  WebService.swift
//  Qschoolgolf
//
//  Created by Baltej Singh on 06/01/20.
//  Copyright © 2020 Wegile. All rights reserved.
//

import UIKit
import SVProgressHUD


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
                    SVProgressHUD.dismiss()
                    
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
                        SVProgressHUD.dismiss()
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
                            SVProgressHUD.dismiss()
                            
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


