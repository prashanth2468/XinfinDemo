//
//  Extensions.swift
//  XinFinDemo
//
//  Created by Developer on 03/06/21.
//


import Foundation

public protocol XinfinExtendable {
    associatedtype T
    var Xinfin3: T { get }
}

public extension XinfinExtendable {
    var Xinfin3: XinfinExtensions<Self> {
        return XinfinExtensions(self)
    }
}

public struct XinfinExtensions<Base> {
    internal(set) public var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension Data: XinfinExtendable {}
extension String: XinfinExtendable {}
extension Int : XinfinExtendable {}
