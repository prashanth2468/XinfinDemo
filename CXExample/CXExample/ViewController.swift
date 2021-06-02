//
//  ViewController.swift
//  CXExample
//
//  Created by Rama's_iMac on 26/05/21.
//

import UIKit
import XinFinDemo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        XinFinValidator.helloXinFin()
        let xinfinAPI = XinFinMethods()
         xinfinAPI.getTransactionDetails(txHash: "0xd2d93b7617438534f48e078c3df0a8734e58af9bff9d1ab62697520855a2138d", success: { (successData) in
             print(successData.hashValue)
             
         })
        
        // Do any additional setup after loading the view.
    }


}

