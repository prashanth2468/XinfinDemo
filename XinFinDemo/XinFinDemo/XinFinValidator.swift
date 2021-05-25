//
//  XinFinValidator.swift
//  XinFinDemo
//
//  Created by Rama's_iMac on 25/05/21.
//

import Foundation

public struct XinFinValidator{
    
 public  static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
 public  static func helloXinFin(){
        print("Hellow Welcome to the Xinfin World")
    }
}

