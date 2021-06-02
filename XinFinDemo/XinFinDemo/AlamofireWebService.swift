//
//  Alamofire.swift
//  TheCollectorExchange
//
//  Created by Ayush Parashar on 30/11/20.
//  Copyright © 2020 Parangat(Gautam). All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class WebService {
    static func callGetAPI(url: URL, headers:[String:String], success: @escaping ((Any)->Void), failure: @escaping ((Error)->Void) ){
        print("URL:\(url.absoluteString)")
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 120.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                failure(error!)
                
            } else {
                let str = String.init(data: data!, encoding: .utf8)
                print("str = \(String(format: "%@", str!))")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        DispatchQueue.main.async {
                            success(json)
                        }
                    }
                } catch let parseError {
                    DispatchQueue.main.async {
                        failure(parseError)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    static func callPostAPI(url: URL, headers:[String:String],param:[String:Any], success: @escaping ((Any)->Void), failure: @escaping ((Error)->Void) ){
        print("URL:\(url.absoluteString)")
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: param, options: [])
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 120.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                    failure(error!)
                    
                } else {
                    let str = String.init(data: data!, encoding: .utf8)
                    print("str = \(String(format: "%@", str!))")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            DispatchQueue.main.async {
                                success(json)
                            }
                        }
                    } catch let parseError {
                        DispatchQueue.main.async {
                            failure(parseError)
                        }
                    }
                }
            })
            
            dataTask.resume()
            
            
        } catch let err {
            failure(err)
        }
        
    }
    
    static func callDeleteAPI(url: URL, headers:[String:String], success: @escaping ((Any)->Void), failure: @escaping ((Error)->Void) ){
        print("URL:\(url.absoluteString)")
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 120.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                failure(error!)
                
            } else {
                let str = String.init(data: data!, encoding: .utf8)
                print("str = \(String(format: "%@", str!))")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        DispatchQueue.main.async {
                            success(json)
                        }
                    }
                } catch let parseError {
                    if(str == "" && (response as! HTTPURLResponse).statusCode == 204){
                        success(["status":"success"])
                        return
                    }
                    
                    DispatchQueue.main.async {
                        failure(parseError)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
}

class AlamoWebServices {
    
  
    func PostWebServices(url : String?, intCurrentState : Int?, strId : String?, withParameters parameters: [String : Any]?, httpMethod : HTTPMethod?, success: @escaping (Data) -> (),failure:@escaping(String) -> ()) {
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: parameters as Any, options:JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(json!)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        print(request)
        Alamofire.request(request).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                if let result = response.data {
                    success(result)
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled {
                    //timeout here
                    failure("The request timed out")
                } else if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                    failure("The internet connection appears to be offline")
                }
            }
        }
    }
    
    func postJSON(path:String,Parameters:[String:Any],success:@escaping(Any)->(),failure:@escaping(Any)->()) {
        Alamofire.request(path,method:.post,parameters:Parameters).responseJSON { (response) in
            
            switch response.result{
            case .success(let data):
                if response.response?.statusCode == 200  {
                    success(data)
                }
            case .failure(let error):
                if response.response?.statusCode != nil {
                    failure(error.localizedDescription)
                }else {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func getDataFromServerWithoutBody(path:String,type:HTTPMethod,sessionId:String,success: @escaping (Data) -> (),failure:@escaping(String) -> ()) {
        
        if !Connectivity.isConnectedToInternet() {
            UIApplication.shared.endIgnoringInteractionEvents()
            failure("The internet connection appears to be offline")
            return
        }
        let headers: HTTPHeaders = [
            
            "Content-Type": "application/json",
            "Authorization" : sessionId

        ]
        if  let completPath = URL(string: path) {
          
            Alamofire.request(completPath,method:type,headers:headers).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    print(value)
                    if let result = response.data {
                        success(result)
                    }
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled {
                        //timeout here
                        failure("The request timed out")
                    }
                    else if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                        failure("The internet connection appears to be offline")
                    }
                }
            }
        }
    }
    
    func getDataFromServerWithParams(path:String,type:HTTPMethod,parameters:[String:Any],success: @escaping (Data) -> (),failure:@escaping(String) -> ()) {
          
          if !Connectivity.isConnectedToInternet() {
              UIApplication.shared.endIgnoringInteractionEvents()
              failure("The internet connection appears to be offline")
              return
          }
          let headers: HTTPHeaders = [
              
              "Content-Type": "application/json"
              
          ]
          if  let completPath = URL(string: path) {
              
              Alamofire.request(completPath,method:type,parameters:parameters,headers:headers).responseJSON { (response) in
                  switch response.result{
                  case .success(let value):
                      print(value)
                      if let result = response.data {
                          success(result)
                      }
                  case .failure(let error):
                      if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled {
                          //timeout here
                          failure("The request timed out")
                      }
                      else if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                          failure("The internet connection appears to be offline")
                      }
                  }
              }
          }
      }
    

    func getDataFromServer(path:String,type:HTTPMethod,sessionId:String,parameters:[String:Any],success: @escaping (Data) -> (),failure:@escaping(String) -> ()) {
        
      if !Connectivity.isConnectedToInternet() {
          failure("The internet connection appears to be offline")
          return
      }
          let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : sessionId
            
          ]
          
          if  let completPath = URL(string: path) {
          
              Alamofire.request(completPath,method:type,parameters:parameters,encoding:  JSONEncoding.default,headers:headers).responseJSON { (response) in
                  switch response.result{
                  case .success(let value):
                      print(value)
                      if let result = response.data {
                          success(result)
                      }
                  case .failure(let error):
                      if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled {
                          //timeout here
                          failure("The request timed out")
                      }
                      else if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                          failure("The internet connection appears to be offline")
                      }
                  }
              }
          }
      }
 
    func PostAuctionAllBidsWebServices(url : String?, intCurrentState : Int?, strId : String?, withParameters parameters: [String : Any]?, httpMethod : HTTPMethod?, success: @escaping (Data) -> (),failure:@escaping(String) -> ()) {
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: parameters as Any, options:JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(json!)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        print(request)
        Alamofire.request(request).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                if let result = response.data {
                    success(result)
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled {
                    //timeout here
                    failure("The request timed out")
                } else if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                    failure("The internet connection appears to be offline")
                }
            }
        }
    }
    
    func CallGetWebServices(url : String?, intCurrentState : Int?, strId : String?, withParameters parameters: [String : Any]?, httpMethod : HTTPMethod?, withSuccessHandler: @escaping (Bool, String) -> Void, withErrorHandler: @escaping (Error) -> Void) {
        
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = HTTPMethod.get.rawValue
        //        let extoken = "\(UserDefaults.standard.string(forKey: "fullAccToken")!)"
        //        request.setValue(extoken, forHTTPHeaderField: "authorization" )
        //        request.setValue("no-cache", forHTTPHeaderField:"cache-control")
        request.setValue("application/json", forHTTPHeaderField:"accept" )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: parameters as Any, options:JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(json!)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        print(request)
        Alamofire.request(request).responseString { response in
            print(response)
            if (response.response?.statusCode != nil){
                switch response.response!.statusCode {
                case 201:
                    print("Success")
                    withSuccessHandler(true, "Success")
                    print(json as Any)
                default:
                    withSuccessHandler(false, "Error occurred")
                    print("dEfault")
                }
                switch response.result {
                case .success:
                    print("Success")
                    break
                case .failure(let error):
                    withErrorHandler(error)
                }
            }
        }
    }
    
}

