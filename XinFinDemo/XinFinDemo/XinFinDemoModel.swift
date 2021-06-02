//
//  XinFinDemoModel.swift
//  XinFinDemo
//
//  Created by Prashanth on 02/06/21.
//

import Foundation


// MARK: - Welcome
struct XinFinDemoModel: Codable {
    let jsonrpc: String?
    let id: Int?
    let result: Result?
}

// MARK: - Result
struct Result: Codable {
    let blockHash, blockNumber, from, gas: String?
    let gasPrice, hash, input, nonce: String?
    let to: JSONNull?
    let transactionIndex, value, v, r: String?
    let s: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
