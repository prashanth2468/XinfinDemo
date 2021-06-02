//
//  XinFinValidator.swift
//  XinFinDemo
//
//  Created by Rama's_iMac on 25/05/21.
//

import Foundation

public struct XinFinValidator {
    
 public  static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
 public  static func helloXinFin(){
        print("Hellow Welcome to the Xinfin World")
    }
    let Alamo_object = AlamoWebServices()

    public init(){
    }
    
    public func getTransactionDetails(txHash:String , success: @escaping (Data) -> ()) {
    
    let parameters: [String: Any] = [
        "jsonrpc": "2.0",
         "method": "eth_getTransactionByHash",
         "params": [
            txHash
         ],
         "id": 1

    ]
        
    print(parameters)
    
    let strEncoded = "https://rpc.apothem.network/getTransactionByHash"

    // Do: AuthToken
        Alamo_object.getDataFromServer(path: strEncoded , type: .post, sessionId:"", parameters: parameters, success: { (successData) in
        print(successData)
        
        do {
            let jsonDecoder = JSONDecoder()
            let userdata = try jsonDecoder.decode(XinFinDemoModel.self, from: successData)
              success(successData)
        }
        catch let jsonErr {
            print("Error decoding Json Questons", jsonErr)
            print("Error decoding Json Questons", jsonErr.localizedDescription)
        }

    }, failure: { (errorType) in
        print(errorType)
    })
    
    }
    
    
}

