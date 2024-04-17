//
//  Data+Extension.swift
//  SwipeProducts
//
//  Created by Sanjeev RM on 17/04/24.
//

import Foundation

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
