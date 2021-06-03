//
//  HexExtensions.swift
//  XinFinDemo
//
//  Created by Developer on 03/06/21.
//

//
//  HexExtensions.swift
//  web3swift
//
//  Created by Matt Marshall on 09/03/2018.
//  Copyright © 2018 Argent Labs Limited. All rights reserved.
//

import Foundation



public extension Int {
    init?(hex: String) {
        self.init(hex.Xinfin3.noHexPrefix, radix: 16)
    }
}


public extension XinfinExtensions where Base == Data {
    var hexString: String {
        let bytes = Array<UInt8>(base)
        return "0x" + bytes.map { String(format: "%02hhx", $0) }.joined()
    }
}

public extension String {
    init(bytes: [UInt8]) {
        self.init("0x" + bytes.map { String(format: "%02hhx", $0) }.joined())
    }
}

public extension XinfinExtensions where Base == String {
    var noHexPrefix: String {
        if base.hasPrefix("0x") {
            let index = base.index(base.startIndex, offsetBy: 2)
            return String(base[index...])
        }
        return base
    }
    
    var withHexPrefix: String {
        if !base.hasPrefix("0x") {
            return "0x" + base
        }
        return base
    }

}
