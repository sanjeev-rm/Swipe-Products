//
//  Data+Extension.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 17/04/24.
//

import Foundation

// An extension of Data, where we append to get information
public extension Data {

    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}
